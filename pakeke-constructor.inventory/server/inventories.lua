


local inv_ents = group("inventory")
-- group of all entities that have an `inventory` component.

local invCtor = require("inventory")
local valid_callbacks = require("inventory_callbacks")


local function assertValidCallbacks(callbacks)
    for cbname, func in pairs(callbacks) do
        assert(valid_callbacks[cbname], "Callback didn't exist: " .. tostring(cbname))
        assert(type(func) == "function", "Callback type was not a function: " .. tostring(cbname))
    end
end


inv_ents:on_added(function(ent)
    if ent.inventoryCallbacks then
        assertValidCallbacks(ent.inventoryCallbacks)
    end

    if not getmetatable(ent.inventory) then
        -- Then the inventory hasn't been initialized and we should init it.
        ent.inventory = invCtor(ent.inventory)
        ent.inventory.owner = ent
    end
end)




inv_ents:on_removed(function(ent)
    -- delete all entities inside the inventory   
end)




on("setInventoryItem", function(inventory, x, y, item_ent)
    server.broadcast("setInventoryItem", inventory.owner, x, y, item_ent)
end)



server.on("trySwapInventoryItem",
function(username, ent, other_ent, x, y, other_x, other_y)
    --[[
        x, y, other_x, other_y are coordinates of the position
        IN THE INVENTORY.
        Not the position of an entity or anything!
    ]]

end)


local function hasCallback(ent, callbackName)
    return ent.inventoryCallbacks and ent.inventoryCallbacks[callbackName]
end



server.on("tryMoveInventoryItem",
function(username, ent, other_ent, x, y, x2, y2, count)
    --[[
        x, y, other_x, other_y are coordinates of the position
        IN THE INVENTORY.
        Not the position of an entity or anything!
    ]]
    local inv1 = ent.inventory
    local inv2 = other_ent.inventory
    -- moving `item` from `inv1` to `inv2`

    local item = inv1:get(x,y)

    if count <= 0 then
        return -- ooohkay?? exit here i guess
    end

    local stackSize = (item.stackSize or 1)
    count = count or stackSize
    if count > stackSize then
        -- Is the client trying to cheat, or what? lol
        count = stackSize
    end

    if not exists(item) then
        return -- Nothing to move; exit early
    end

    if inv1.private and ent.controller ~= username then
        return -- exit early
    end
    if inv2.private and other_ent.controller ~= username then
        return -- exit early
    end
    
    if hasCallback(ent, "canRemove") then
        if not ent.inventoryCallbacks.canRemove(inv1, item, x, y) then
            return -- exit early
        end
    end

    if hasCallback(other_ent, "canAdd") then
        if not ent.inventoryCallbacks.canAdd(inv2, item, x2, y2) then
            return -- exit early
        end
    end

    if count < stackSize then
        -- Damn, gotta create a new entity
    end
end)




server.on("tryDropInventoryItem",
function(username, ent, x, y)
    --[[
        x, y, are coordinates of the position
        IN THE INVENTORY.
        Not the position of an entity or anything!
    ]]
    local inv = ent.inventory
    if inv.private and ent.controller ~= username then
        return
    end

    local item = inv:get(x,y)
    if not item then
        return
    end

    if ent.inventoryCallbacks then
        if not ent.inventoryCallbacks.canRemove(inv, item, x, y) then
            return
        end
    end

    -- Update item
    item.hidden = false
    item.x = ent.x
    item.y = ent.y

    -- Syncs state of item to clients
    server.sync(item, "hidden")
    server.sync(item, "x")
    server.sync(item, "y")
    
    inv:set(x, y, nil)
end)


