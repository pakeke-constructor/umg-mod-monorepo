


local inventoryGroup = umg.group("inventory")
-- group of all ents that have an `inventory` component.

local Inventory = require("shared.inventory")
local valid_callbacks = require("shared.inventory_callbacks")

local groundItemsHandler = require("server.ground_items_handler")





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

    ent.inventory:setup(ent)
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



local sf = sync.filters


local function hasAccess(controlEnt, invEnt)
    --[[
        `controlEnt` is the entity executing the transfer upon invEnt.
        invEnt is the entity holding the inventory

        TODO: Do we want a maximum interaction distance enforced here???
    ]]
    if not umg.exists(invEnt) then
        return false
    end
    if not invEnt.inventory then
        return false
    end

    return invEnt.inventory:canBeOpenedBy(controlEnt)
end



server.on("trySwapInventoryItem", {
    arguments = {
        sf.controlEntity,
        sf.entity,
        sf.entity,
        sf.number,
        sf.number,
        sf.number,
        sf.number
    },

    handler = function(sender, controlEnt, ent, other_ent, x, y, x2, y2)
        --[[
            x, y, other_x, other_y are coordinates of the position
            IN THE INVENTORY.
            Not the position of an entity or anything!
        ]]
        if not (hasAccess(controlEnt, ent) and hasAccess(controlEnt, other_ent)) then
            return
        end

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
        
        if not (inv1:hasAddAuthority(controlEnt,item2,x,y) and inv1:hasRemoveAuthority(controlEnt,x,y)) then
            return
        end
        if not (inv2:hasAddAuthority(controlEnt,item1,x2,y2) and inv2:hasRemoveAuthority(controlEnt,x2,y2)) then
            return
        end
        
        inv1:trySwap(x,y, inv2, x2,y2)
    end
})



server.on("tryMoveInventoryItem", {
    arguments = {
        sf.controlEntity,
        sf.entity,
        sf.entity,
        sf.number,
        sf.number,
        sf.number,
        sf.number
    },

    handler = function(sender, controlEnt, ent, other_ent, x, y, x2, y2, count)
        --[[
            x, y, other_x, other_y are coordinates of the position
            IN THE INVENTORY.
            Not the position of an entity or anything!
        ]]
        if not (hasAccess(controlEnt, ent) and hasAccess(controlEnt, other_ent)) then
            return
        end
        count = count or 1

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
        if not inv2:hasAddAuthority(controlEnt,item,x2,y2) then
            return
        end
        if not inv1:hasRemoveAuthority(controlEnt, x,y) then
            return
        end

        inv1:tryMoveToSlot(x,y, inv2, x2,y2, count)
    end
})




server.on("tryDropInventoryItem", {
    arguments = {sf.controlEntity, sf.entity, sf.number, sf.number},

    handler = function(sender, controlEnt, ent, slotX, slotY)
        --[[
            x, y, are coordinates of the position
            IN THE INVENTORY.
            Not the position of an entity or anything!
        ]]
        local inv = ent.inventory
        
        if not (hasAccess(controlEnt, ent)) then
            return
        end
        if not inv:canBeOpenedBy(ent) then
            return
        end

        local item = inv:get(slotX, slotY)
        if not item then
            return -- exit early
        end

        if not inv:hasRemoveAuthority(controlEnt,slotX,slotY) then
            return
        end

        groundItemsHandler.drop(item, ent.x, ent.y)
        inv:set(slotX, slotY, nil)
    end
})


