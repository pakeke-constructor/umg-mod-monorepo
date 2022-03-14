


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
    -- What do we actually do here??
    -- if we delete the entities, then it gives no options to the modders
    -- in terms of item drops.
    -- However, if we *dont* delete the items, then its a memory leak  :/
end)





on("setInventoryItem", function(inventory, x, y, item_ent)
    server.broadcast("setInventoryItem", inventory.owner, x, y, item_ent)
end)




local function drop(item, x, y)
    --[[
        Drops item on to the ground
    ]]
    item.hidden = false
    item.x = (x or item.x) or 0
    item.y = (y or item.y) or 0

    -- Syncs state of item to clients
    server.sync(item, "hidden")
    server.sync(item, "x")
    server.sync(item, "y")
end



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



local function hasAccess(username, ent)
    --[[
        returns true/false, depending on whether this username has access
        to `ent`s inventory.
    ]]
    local inv = ent.inventory
    if inv.private and ent.controller ~= username then
        return false
    else
        return true
    end
end



server.on("trySwapInventoryItem",
function(username, ent, other_ent, x, y, x2, y2)
    --[[
        x, y, other_x, other_y are coordinates of the position
        IN THE INVENTORY.
        Not the position of an entity or anything!
    ]]
    local inv1 = ent.inventory
    local inv2 = other_ent.inventory
    
    local item1 = inv1:get(x,y)
    local item2 = inv2:get(x2,y2)

    if not (hasAccess(username, ent) and hasAccess(username, other_ent)) then
        return -- this user doesn't have access to both inventories!
        -- welp!
    end
    
    if not checkCallback(ent, "canRemove", x, y, item1) then
        return -- exit early
    end
    if not checkCallback(ent, "canAdd", x, y, item2) then
        return -- exit early
    end
    if not checkCallback(other_ent, "canRemove", x, y, item2) then
        return -- exit early
    end
    if not checkCallback(other_ent, "canAdd", x, y, item1) then
        return -- exit early
    end

    inv1:set(x, y, item2)
    inv2:set(x2, y2, item1)
end)



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
    if not (hasAccess(username, ent) and hasAccess(username, other_ent)) then
        return -- this user doesn't have access to both inventories!
    end
    if not checkCallback(ent, "canRemove", x, y) then
        return -- exit early
    end
    if not checkCallback(other_ent, "canAdd", x2, y2) then
        return -- exit early
    end
    if inv2:get(x2, y2) then
        -- welp, we are replacing item2!
        if not checkCallback(other_ent, "canRemove", x2, y2) then
            return -- exit early
        end
    end

    if count < stackSize then
        -- Damn, gotta create a new entity
        local typename = item:type()
        local new = entities[typename]()
        new.stackSize = count
        item.stackSize = stackSize - count
        inv2:set(x2, y2, new)
    else
        -- Else we just move it
        inv1:set(x, y, nil)
        inv2:set(x2, y2, item)
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

    if not checkCallback(ent, "canRemove", x, y) then
        return -- exit early
    end

    drop(item, ent.x, ent.y)
    
    inv:set(x, y, nil)
end)


