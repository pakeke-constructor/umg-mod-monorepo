
local invCtor = require("inventory")


local inv_ents = group("inventory")
-- group of all entities that have an `inventory` component.


inv_ents:on_added(function(ent)
    if not ent.inventory then
         -- Oh no! entity doesn't have a .inventory field yet.
        -- Lets try to initialize the entity.
        if ent.init then
            ent:init()
        end
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
end)


local function execute_interaction(inv, mx, my)

end



on("mousepressed", function(mx, my, button)
    local len = #open_inventories
    for i=len, 1, -1 do
        local inv = open_inventories[i]
        if inv:withinBounds(mx, my) then
            if i == len then
                -- It's top inventory, is interactable.
                dragging_inv = inv
                execute_interaction(inv, mx, my)
                return
            else
                -- It's at the bottom- bring to top.
                dragging_inv = inv
                table.remove(open_inventories, i)
                table.insert(open_inventories, inv)
                return
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


