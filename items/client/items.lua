
local Inventory = require("inventory")


local inventoryGroup = umg.group("inventory")
-- group of all entities that have an `inventory` component.

local controlGroup = umg.group("controller")




local INVSLOTS_ERR = "inventorySlots size must match dimensions of inventory"
local function assertInventorySlotsValid(ent)
    local inventory = ent.inventory
    local inventorySlots = ent.inventorySlots
    assert(#inventorySlots == inventory.height, INVSLOTS_ERR)
    for _, ar in ipairs(inventorySlots) do
        assert(#ar == inventory.width, INVSLOTS_ERR)
    end
end



inventoryGroup:onAdded(function(ent)
    if (not ent.inventory) or (getmetatable(ent.inventory) ~= Inventory) then
        error("Inventory component must be initialized either before entity creation, or inside a `.init` function!")
    end
    if ent.inventorySlots then
        assertInventorySlotsValid(ent)
    end
    ent.inventory.owner = ent
end)



local open_inventories = {}



--[[
    The inventory, along with the x and y of the item
    that the player is holding.
]]
local focus_inv -- The inventory that is currently being focused
local focus_x -- X pos in holding inv
local focus_y -- Y pos in holding inv
local focus_half_stack -- whether only half a stack is being held
-- (This is true if it was picked up by BETA_BUTTON. (right click))


-- The inventory that is being dragged around by the player
local dragging_inv


local function remove_from(tabl, item)
    -- removes item from flat array.
    -- Usually I would use sets, but for this I want to modify the order easily.
    -- (Messing around with the order of sets is a recipe for disaster.)
    local len = #tabl 
    for i=len, 1, -1 do
        if tabl[i] == item then
            table.remove(tabl, i)
        end
    end
end


inventoryGroup:onRemoved(function(ent)
    local inv = ent.inventory
    if focus_inv == inv then
        focus_inv, focus_x, focus_y = nil, nil, nil
    end
    remove_from(open_inventories, inv)
end)


umg.on("openInventory", function(owner_ent)
    table.insert(open_inventories, owner_ent.inventory)
end)


umg.on("closeInventory", function(owner_ent)
    local inv = owner_ent.inventory
    remove_from(open_inventories, inv)

    if focus_inv == inv then
        -- stop holding of item
        focus_inv = nil
        focus_x = nil
        focus_y = nil
    end
end)


local function checkCallback(ent, callbackName, x, y, item)
    --[[
        returns true/false according to inventoryCallbacks component.
        (Only works on `canRemove` and `canAdd`!!!)
    ]]
    if ent.inventoryCallbacks and ent.inventoryCallbacks[callbackName] then
        item = item or ent.inventory:get(x,y)
        return ent.inventoryCallbacks[callbackName](ent.inventory, x, y, item)
    end
    return true -- return true otherwise (no callbacks)
end





local function resetHoldingInv()
    focus_inv = nil
    focus_x = nil
    focus_y = nil
    focus_half_stack = nil
end


local function getControlEntity(inv)
    local slf = client.getUsername()
    for _, ent in ipairs(controlGroup) do
        if ent.controller == slf then
            if inv:canBeOpenedBy(ent) then
                return ent
            end
        end
    end
    return false
end


local function getControlTransferEntity(inv1, inv2)
    --[[
        Players can only move things around inventories
        if they have a controlEnt that can facilitate the transer.

        look through all controlled entities, filter for
        the ones controlled by the client, and return any that
        are able to make the transfer between inv1 and inv2.
    ]]
    local slf = client.getUsername()
    for _, ent in ipairs(controlGroup) do
        if ent.controller == slf then
            if inv1:canBeOpenedBy(ent) then
                if inv2 == inv1 or inv2:canBeOpenedBy(ent) then
                    return ent
                end
            end
        end
    end
    return false
end



local function executeFullPut(inv, x, y)
    local controlEnt = getControlTransferEntity(inv, focus_inv)

    -- Ok... so `holding` exists.
    local holding = focus_inv:get(focus_x, focus_y)
    if not umg.exists(holding) then
        resetHoldingInv()
        return -- erm, okay? I guess the entity was deleted, so we just ignore this
    end

    if (inv==focus_inv) and (x==focus_x) and (y==focus_y) then
        resetHoldingInv()
        return -- moving an item to it's own position...? nope!
    end

    local swapping = false
    local move_count
    local targ = inv:get(x,y)
    if targ then
        if targ.itemName == holding.itemName then
            if targ.stackSize == targ.maxStackSize and holding.stackSize == holding.maxStackSize then
                swapping = true
            else
                -- they stack!  (no need to swap)
                swapping = false
                local div = focus_half_stack and 2 or 1
                move_count = math.min(math.ceil(holding.stackSize/div), targ.maxStackSize - targ.stackSize)
            end            
        else
            -- We are swapping- so lets check that we actually can:
            swapping = true
            local c1 = checkCallback(focus_inv.owner, "canAdd", focus_x, focus_y)
            local c2 = checkCallback(inv.owner, "canRemove", x, y)
            if not (c1 and c2) then
                return
            end
        end
    end

    if not checkCallback(inv.owner, "canAdd", x, y, holding) then
        return
    end

    if not checkCallback(focus_inv.owner, "canRemove", focus_x, focus_y) then
        return
    end

    if swapping then
        client.send("trySwapInventoryItem", controlEnt, focus_inv.owner, inv.owner, focus_x,focus_y, x,y)
    else
        if not move_count then
            move_count = math.ceil(holding.stackSize / (focus_half_stack and 2 or 1))
        end
        client.send("tryMoveInventoryItem", controlEnt, focus_inv.owner, inv.owner, focus_x,focus_y, x,y, move_count)
    end

    resetHoldingInv()
end




local function executeAlphaInteraction(inv, slot_x, slot_y)
    --[[
        "alpha" interactions are for stuff like placing full stacks
        of items, etc.
    ]]
    if focus_inv and umg.exists(focus_inv.owner) and focus_inv:get(focus_x, focus_y) then
        executeFullPut(inv, slot_x, slot_y)
    else
        -- Else we just set the holding to a value, so long as there is an item
        -- in the target slot:
        focus_inv = inv
        focus_x = slot_x
        focus_y = slot_y
        inv:setHover(slot_x, slot_y)
        focus_half_stack = false
        if not inv:get(slot_x,slot_y) then
            resetHoldingInv()
        end
    end
end


local function executeBetaInteraction(inv, x, y)
    --[[
        "beta" interactions are for placing one item out of an entire stack,
        or splitting a stack.
    ]]
    if focus_inv and umg.exists(focus_inv.owner) and focus_inv:get(focus_x, focus_y) then
        local controlEnt = getControlTransferEntity(inv, focus_inv)
        local holding_item = focus_inv:get(focus_x, focus_y)
        if not checkCallback(inv.owner, "canAdd", x, y, holding_item) then
            return
        end
        if not checkCallback(focus_inv.owner, "canRemove", focus_x, focus_y) then
            return
        end
        local targ = inv:get(x,y)
        if (not targ) or targ.itemName == holding_item.itemName then
            client.send("tryMoveInventoryItem", controlEnt, focus_inv.owner, inv.owner, focus_x,focus_y, x,y, 1)
        end
    else
        focus_inv = inv
        focus_x = x
        focus_y = y
        focus_half_stack = true
        if not inv:get(x,y) then
            resetHoldingInv()
        end
    end
end


local ALPHA_BUTTON = 1
local BETA_BUTTON = 2 -- right click is clearly inferior 


local listener = base.client.input.Listener({priority = 5})


function listener:mousepressed(mx, my, button)
    local len = #open_inventories
    local loop_used = false
    for i=len, 1, -1 do
        local inv = open_inventories[i]
        if inv:withinBounds(mx, my) then
            loop_used = true
            if i ~= len then
                table.remove(open_inventories, i)
                table.insert(open_inventories, inv)
            end
            local slotX, slotY = inv:getSlot(mx,my)
            if slotX then
                if inv:slotExists(slotX, slotY) then
                    if button == ALPHA_BUTTON then
                        self:lockMouseButton(ALPHA_BUTTON)
                        executeAlphaInteraction(inv, slotX, slotY)
                    elseif button == BETA_BUTTON then
                        self:lockMouseButton(BETA_BUTTON)
                        executeBetaInteraction(inv, slotX, slotY)
                    end
                elseif button == ALPHA_BUTTON then
                    self:lockMouseButton(ALPHA_BUTTON)
                    dragging_inv = inv
                    resetHoldingInv()
                end
                break -- done; only 1 interaction should be done per click.
            elseif button == ALPHA_BUTTON then
                self:lockMouseButton(ALPHA_BUTTON)
                dragging_inv = inv
                resetHoldingInv()
                break
            end
        end
    end

    if (not loop_used) and focus_inv then
        if button == ALPHA_BUTTON then    
            -- Then the player wants to drop an item on the floor:
            if umg.exists(focus_inv:get(focus_x, focus_y)) then
                local controlEnt = getControlEntity(focus_inv)
                client.send("tryDropInventoryItem", controlEnt, focus_inv.owner, focus_x, focus_y)
            end
            self:lockMouseButton(ALPHA_BUTTON)
        elseif button == BETA_BUTTON then
            resetHoldingInv()
            self:lockMouseButton(BETA_BUTTON)
        end
    end
end


function listener:mousemoved(mx,my, dx, dy)
    -- used for dragging inventories around
    if dragging_inv then
        local ui_scale = base.client.getUIScale()
        dx, dy = dx / ui_scale, dy / ui_scale
        dragging_inv.draw_x = dragging_inv.draw_x + dx
        dragging_inv.draw_y = dragging_inv.draw_y + dy
    end
end


function listener:mousereleased(mx,my, button)
    dragging_inv = nil
end


umg.on("slabUpdate", function()
    for _, inv in ipairs(open_inventories) do
        if inv.isOpen then
            inv:updateSlabUI()
        end
    end
end)


umg.on("mainDrawUI", function()
    for _, inv in ipairs(open_inventories) do
        inv:drawUI()
    end
    
    if focus_inv then
        focus_inv:drawHoverWidget(focus_x, focus_y)
    end
end)



client.on("setInventoryItem", function(ent, x, y, item_ent)
    local inventory = ent.inventory
    inventory:_rawset(x,y,item_ent)
    if inventory == focus_inv and x == focus_x and y == focus_y then
        resetHoldingInv()
    end
end)


client.on("setInventoryItemStackSize", function(item, stackSize)
    item.stackSize = stackSize
end)



client.on("setInventoryHoldSlot", function(ent, x, y)
    local inv = ent.inventory
    if inv then
        inv:_setHoldSlot(x, y)
    end
end)

