


local inventoryGroup = umg.group("inventory")
-- group of all ents that have an `inventory` component.

local Inventory = require("inventory")
local valid_callbacks = require("inventory_callbacks")

local groundItemsHandler = require("server.ground_items_handler")

local updateStackSize = require("server.update_stacksize")





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


server.on("setInventoryHoldSlot", {
    arguments = {sf.controlEntity, sf.number, sf.number},
    handler = function(sender, ent, slotX, slotY)
        if not ent.inventory then return end
        slotX = math.floor(slotX)
        slotY = math.floor(slotY)
        
        local inv = ent.inventory
        if slotX <= inv.width and slotX >= 1 and slotY <= inv.height and slotY >= 1 then
            if inv:slotExists(slotX,slotY) then
                inv:hold(slotX,slotY)
            end
        end
    end
})





local function hasAccess(controlEnt, invEnt)
    --[[
        `controlEnt` is the entity executing the transfer upon invEnt.
        invEnt is the entity holding the inventory

        TODO: Do we want a maximum interaction distance enforced here???
    ]]
    if umg.exists(invEnt) then
        return false
    end
   if invEnt.inventory then
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
        if not (hasAccess(controlEnt, ent) and hasAccess(controlEnt, other_ent)) then return end

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
        
        if not (inv1:hasAddAuthority(controlEnt,x,y,item2) and inv1:hasRemoveAuthority(controlEnt,x,y)) then
            return false
        end
        if not (inv2:hasAddAuthority(controlEnt,x2,y2,item1) and inv2:hasRemoveAuthority(controlEnt,x2,y2)) then
            return false
        end

        inv1:set(x, y, item2)
        inv2:set(x2, y2, item1)
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
                inv2:set(x2, y2, new)
                updateStackSize(item)
            else
                -- Else we just move it
                inv1:set(x, y, nil)
                inv2:set(x2, y2, item)
            end
        end
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
        if not inv:canBeOpenedBy(ent) then
            return
        end

        local item = inv:get(slotX, slotY)
        if not item then
            return -- exit early
        end

        if not inv:slotExists(slotX, slotY) then
            return  -- exit early
        end

        groundItemsHandler.drop(item, ent.x, ent.y)
        inv:set(slotX, slotY, nil)
    end
})


