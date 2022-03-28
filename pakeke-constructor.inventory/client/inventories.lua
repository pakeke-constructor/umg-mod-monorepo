
local invCtor = require("inventory")


local inv_ents = group("inventory")
-- group of all entities that have an `inventory` component.


inv_ents:on_added(function(ent)
    if not ent.inventory then
        assert(ent.inventory, "Inventory component must be initialized either before entity creation, or inside a `.init` function!")
    end

    if not getmetatable(ent.inventory) then
        -- Then the inventory hasn't been initialized and we should init it.
        ent.inventory = invCtor(ent.inventory)
        ent.inventory.owner = ent
    end
end)


local open_inventories = {}



--[[
    The inventory, along with the x and y of the item
    that the player is holding.
]]
local holding_inv
local holding_x
local holding_y

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


inv_ents:on_removed(function(ent)
    local inv = ent.inventory
    if holding_inv == inv then
        holding_inv, holding_x, holding_y = nil, nil, nil
    end
    table_remove(open_inventories, inv)
end)


on("openInventory", function(inv, owner_ent)
    table.insert(open_inventories, inv)
end)


on("closeInventory", function(inv, owner_ent)
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
end


local function executeFullPut(inv, x, y)
    -- Ok... so `holding` exists.
    local holding = holding_inv:get(x,y)
    if not exists(holding) then
        holding_inv = nil
        holding_x = nil
        holding_y = nil
        return -- erm, okay? I guess we just ignore this
    end

    local swapping = false
    local targ = inv:get(x,y)
    if targ then
        if targ.itemName == holding.itemName and targ.stackSize < targ.maxStackSize then
            -- they stack!  (no need to swap)
            swapping = false
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

    if not checkCallback(holding.owner, "canRemove", holding_x, holding_y) then
        return
    end

    if swapping then
        client.send("trySwapInventoryItem", holding_inv.owner, inv.owner,x,y,holding_x,holding_y)
    else
        client.send("tryMoveInventoryItem", holding_inv.owner, inv.owner,x,y,holding_x,holding_y)
    end
end



local function executeAlphaInteraction(inv, x, y)
    --[[
        "alpha" interactions are for stuff like placing full stacks
        of items, etc.
    ]]
    if holding_inv and exists(holding_inv.owner) and holding_inv:get(holding_x, holding_y) then
        executeFullPut(inv, x, y)
    else
        -- Else we just set the holding to a value.
        holding_inv = inv
        holding_x = x
        holding_y = y
    end
end


local function executeBetaInteraction(inv, x, y) end


local ALPHA_BUTTON = 1
local BETA_BUTTON = 2 -- right click is clearly insuperior 


on("mousepressed", function(mx, my, button)
    local len = #open_inventories
    for i=len, 1, -1 do
        local inv = open_inventories[i]
        if inv:withinBounds(mx, my) then
            if i ~= len then
                table.remove(open_inventories, i)
                table.insert(open_inventories, inv)
            end
            local bx, by = inv:getBucket(mx,my)
            if bx then
                if button == ALPHA_BUTTON then
                   executeAlphaInteraction(inv, bx, by)
                elseif button == BETA_BUTTON then
                    executeBetaInteraction(inv, bx, by)
                end
            elseif button == ALPHA_BUTTON then
                dragging_inv = inv
            end
        elseif holding_inv then
            -- Then the player wants to drop an item
            if exists(holding_inv:get(holding_x, holding_y)) then
                client.send("tryDropInventoryItem", holding_inv.owner, holding_x, holding_y)
            end
        end
    end
end)



on("mousemoved", function(mx,my, dx, dy)
    -- used for dragging inventories around
    if dragging_inv then
        local ui_scale = graphics.getUIScale()
        dx, dy = dx / ui_scale, dy / ui_scale
        dragging_inv.draw_x = dragging_inv.draw_x + dx
        dragging_inv.draw_y = dragging_inv.draw_y + dy
    end
end)

on("mousereleased", function(mx,my, button)
    dragging_inv = nil
end)


on("mainDrawUI", function()
    for i, inv in ipairs(open_inventories) do
        inv:drawUI()
    end
    
    if holding_inv then
        local item = holding_inv:get(holding_x, holding_y)
        local mx, my = mouse.getPosition()
        local ui_scale = graphics.getUIScale()
        mx, my = mx / ui_scale, my / ui_scale
        if item then
            holding_inv:drawItem(item, mx, my)
        end
    end
end)



client.on("setInventoryItem", function(ent, x, y, item_ent)
    local inventory = ent.inventory
    inventory:set(x,y,item_ent)
end)


client.on("dropInventoryItem", function(item, x, y)
    item.x = x
    item.y = y
    item.hidden = false
end)


client.on("pickUpInventoryItem", function(item)
    item.hidden = true
end)

