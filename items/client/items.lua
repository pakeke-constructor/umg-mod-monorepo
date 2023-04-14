
local Inventory = require("inventory")


local inventoryGroup = umg.group("inventory")
-- group of all entities that have an `inventory` component.




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
local holding_inv -- The inventory that is currently being focused
local holding_x -- X pos in holding inv
local holding_y -- Y pos in holding inv
local holding_half -- whether only half a stack is being held
-- (This is true if it was picked up by BETA_BUTTON. (right click))


-- The inventory that is being dragged around by the player
local dragging_inv


local function table_remove(tabl, item)
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
    if holding_inv == inv then
        holding_inv, holding_x, holding_y = nil, nil, nil
    end
    table_remove(open_inventories, inv)
end)


umg.on("openInventory", function(owner_ent)
    table.insert(open_inventories, owner_ent.inventory)
end)


umg.on("closeInventory", function(owner_ent)
    local inv = owner_ent.inventory
    table_remove(open_inventories, inv)

    if holding_inv == inv then
        -- stop holding of item
        holding_inv = nil
        holding_x = nil
        holding_y = nil
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
    holding_inv = nil
    holding_x = nil
    holding_y = nil
    holding_half = nil
end




local function executeFullPut(inv, x, y)
    -- Ok... so `holding` exists.
    local holding = holding_inv:get(holding_x, holding_y)
    if not umg.exists(holding) then
        resetHoldingInv()
        return -- erm, okay? I guess we just ignore this
    end

    if (inv==holding_inv) and (x==holding_x) and (y==holding_y) then
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
                local div = holding_half and 2 or 1
                move_count = math.min(math.ceil(holding.stackSize/div), targ.maxStackSize - targ.stackSize)
            end            
        else
            -- We are swapping- so lets check that we actually can:
            swapping = true
            local c1 = checkCallback(holding_inv.owner, "canAdd", holding_x, holding_y)
            local c2 = checkCallback(inv.owner, "canRemove", x, y)
            if not (c1 and c2) then
                return
            end
        end
    end

    if not checkCallback(inv.owner, "canAdd", x, y, holding) then
        return
    end

    if not checkCallback(holding_inv.owner, "canRemove", holding_x, holding_y) then
        return
    end

    if swapping then
        client.send("trySwapInventoryItem", holding_inv.owner, inv.owner, holding_x,holding_y, x,y)
    else
        if not move_count then
            move_count = math.ceil(holding.stackSize / (holding_half and 2 or 1))
        end
        client.send("tryMoveInventoryItem", holding_inv.owner, inv.owner, holding_x,holding_y, x,y, move_count)
    end

    resetHoldingInv()
end




local function executeAlphaInteraction(inv, x, y)
    --[[
        "alpha" interactions are for stuff like placing full stacks
        of items, etc.
    ]]
    if holding_inv and umg.exists(holding_inv.owner) and holding_inv:get(holding_x, holding_y) then
        executeFullPut(inv, x, y)
    else
        -- Else we just set the holding to a value, so long as there is an item
        -- in the target slot:
        holding_inv = inv
        holding_x = x
        holding_y = y
        inv:setHoverXY(x,y)
        holding_half = false
        if not inv:get(x,y) then
            resetHoldingInv()
        end
    end
end


local function executeBetaInteraction(inv, x, y)
    --[[
        "beta" interactions are for placing one item out of an entire stack,
        or splitting a stack.
    ]]
    if holding_inv and umg.exists(holding_inv.owner) and holding_inv:get(holding_x, holding_y) then
        local holding_item = holding_inv:get(holding_x, holding_y)
        if not checkCallback(inv.owner, "canAdd", x, y, holding_item) then
            return
        end
        if not checkCallback(holding_inv.owner, "canRemove", holding_x, holding_y) then
            return
        end
        local targ = inv:get(x,y)
        if (not targ) or targ.itemName == holding_item.itemName then
            client.send("tryMoveInventoryItem", holding_inv.owner, inv.owner, holding_x,holding_y, x,y, 1)
        end
    else
        holding_inv = inv
        holding_x = x
        holding_y = y
        holding_half = true
        if not inv:get(x,y) then
            resetHoldingInv()
        end
    end
end


local ALPHA_BUTTON = 1
local BETA_BUTTON = 2 -- right click is clearly insuperior 


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

    if (not loop_used) and holding_inv then
        if button == ALPHA_BUTTON then    
            -- Then the player wants to drop an item on the floor:
            if umg.exists(holding_inv:get(holding_x, holding_y)) then
                client.send("tryDropInventoryItem", holding_inv.owner, holding_x, holding_y)
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
    
    if holding_inv then
        holding_inv:drawHoverWidget(holding_x, holding_y)
    end
end)



client.on("setInventoryItem", function(ent, x, y, item_ent)
    local inventory = ent.inventory
    inventory:set(x,y,item_ent)
    if inventory == holding_inv and x == holding_x and y == holding_y then
        resetHoldingInv()
    end
end)


client.on("setInventoryItemStackSize", function(item, stackSize)
    item.stackSize = stackSize
end)



client.on("dropInventoryItem", function(item, x, y)
    assert(x and y, "?")
    item.x = x
    item.y = y
    item.itemBeingHeld = false
    item.hidden = false
end)


client.on("pickUpInventoryItem", function(item)
    item.hidden = true
end)


