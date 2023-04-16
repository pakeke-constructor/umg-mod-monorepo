


local inventoryGroup = umg.group("inventory")
-- group of all ents that have an `inventory` component.

local Inventory = require("inventory")
local valid_callbacks = require("inventory_callbacks")

local updateStackSize = require("server.update_stacksize")

local itemDrops = require("server.item_drops")

local itemHolding = require("server.item_holding")




local function assertValidCallbacks(callbacks)
    for cbname, func in pairs(callbacks) do
        assert(valid_callbacks[cbname], "Callback didn't exist: " .. tostring(cbname))
        assert(type(func) == "function", "Callback type was not a function: " .. tostring(cbname))
    end
end


inventoryGroup:onAdded(function(ent)
    if ent.inventoryCallbacks then
        assertValidCallbacks(ent.inventoryCallbacks)
    end

    if not ent:isRegular("inventory") then
        error(".inventory component must be regular. Not the case for: " ..tostring(ent))
    end
    if (getmetatable(ent.inventory) ~= Inventory) then
        error("inventory was assigned incorrectly for ent: " .. tostring(ent))
    end

    if not ent.stackSize then
        ent.stackSize = 1
    end
    ent.inventory.owner = ent
end)



inventoryGroup:onRemoved(function(ent)
    -- delete items
    local inv = ent.inventory
    for x=1, inv.width do
        for y=1, inv.height do
            local item = inv:get(x, y)
            if umg.exists(item) then
                item:delete()
            end
        end
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






do
local asserter = base.typecheck.check("entity", "integer", "integer")

server.on("setInventoryHoldItem", function(sender, ent, x, y)
    if not asserter(ent, x, y) then return end
    if ent.controller ~= sender then return end
    if not ent.inventory then return end
    
    local inv = ent.inventory
    if x <= inv.width and x >= 1 and y <= inv.height and y >= 1 then
        if inv:slotExists(x,y) then
            itemHolding.setHoldItem(ent, inv:get(x,y))
        end
    end
end)

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
    if (not inv1) or (not inv2) then
        return
    end
    if (not inv1:slotExists(x,y)) or (not inv2:slotExists(x2,y2)) then
        return
    end
    
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
    if not checkCallback(other_ent, "canRemove", x2, y2, item2) then
        return -- exit early
    end
    if not checkCallback(other_ent, "canAdd", x2, y2, item1) then
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
    if (not inv1) or (not inv2) then
        return
    end
    if (not inv1:slotExists(x,y)) or (not inv2:slotExists(x2,y2)) then
        return
    end
    -- moving `item` from `inv1` to `inv2`

    if inv1 == inv2 and (x==x2) and (y==y2) then
        return -- moving an item to it's own position...? nope!
    end

    local item = inv1:get(x,y)
    local targ = inv2:get(x2,y2)

    if not umg.exists(item) then
        return -- Nothing to move; exit early
    end

    local stackSize = item.stackSize or 1
    count = count or stackSize
    count = math.min(count, stackSize)
    if targ then
        count = math.min(count, (targ.maxStackSize or 1) - targ.stackSize)
    end

    if count <= 0 then
        return -- ooohkay?? exit here i guess
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
    if targ then
        -- welp, we are replacing/adding to targ!
        if not checkCallback(other_ent, "canRemove", x2, y2) then
            return -- exit early
        end
    end

    if targ then
        local item_stacksize = item.stackSize - count
        if item_stacksize <= 0 then
            inv1:set(x,y,nil)
            item:delete()
        else
            item.stackSize = item_stacksize
            updateStackSize(item)
        end
        targ.stackSize = targ.stackSize + count
        updateStackSize(item)
    else
        if count < stackSize then
            -- Damn, gotta create a new entity
            local typename = item:type()
            local new = server.entities[typename]()
            new.x = item.x
            new.y = item.y
            new.stackSize = count
            item.stackSize = stackSize - count
            --[[
                TODO::: 
                This is terrible.
                A better thing to do would be to buffer the `inv:set()` manually,
                instead of removing the buffering from the entity spawning
            ]]
            server.forceSpawn(new)
            inv2:set(x2, y2, new)
            updateStackSize(item)
        else
            -- Else we just move it
            inv1:set(x, y, nil)
            inv2:set(x2, y2, item)
        end
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
        return -- exit early
    end

    if not inv:slotExists(x,y) then
        return  -- exit early
    end

    if not checkCallback(ent, "canRemove", x, y) then
        return -- exit early
    end

    -- NOTE: The order that these are called is important.
    itemHolding.releaseItemIfHeld(ent, item)
    itemDrops.dropItem(item, ent.x, ent.y)

    inv:set(x, y, nil)
end)


