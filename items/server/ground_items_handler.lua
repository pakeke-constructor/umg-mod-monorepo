
--[[

Entities that can pick up items off the ground have a `canPickUpItems` component.

]]


local groundItemsHandler = {}




local pickUpGroup = umg.group("x", "y", "canPickUpItems", "inventory")

local groundItemGroup = umg.group("x", "y", "groundItem", "inventory")


local CHUNK_SIZE = 100
local groundItemPartition = base.Partition(CHUNK_SIZE)

local PICKUP_DISTANCE = 24


-- Wait X seconds before being able to pick up dropped items.
-- this way, when an item is dropped on the ground, it isn't instantly picked up.
local PICKUP_DELAY_TIME = 4





local function dropItem(itemEnt, x, y)
    local e = server.entities.items_ground_item(x, y)
    e.inventory:set(1,1,itemEnt)
    e.image = itemEnt.image
    umg.call("dropGroundItem", e, itemEnt)
end



local dropItemHandler = dropItem
local dropItemTc = typecheck.assert("table", "number", "number")

function groundItemsHandler.drop(itemEnt, x, y)
    dropItemTc(itemEnt, x, y)
    dropItemHandler(itemEnt, x, y)
end


function groundItemsHandler.setDropHandler(func)
    dropItemHandler = func
end





groundItemGroup:onAdded(function(e)
    groundItemPartition:addEntity(e)
    e.groundItemSpawnTime = base.getGameTime()
end)


groundItemGroup:onRemoved(function(e)
    groundItemPartition:removeEntity(e)
end)




local function canBePickedUp(dist, item)
    if dist > PICKUP_DISTANCE then 
        return false
    end

    if item.groundItemSpawnTime then
        local time = base.getGameTime() - item.groundItemSpawnTime
        if time < PICKUP_DELAY_TIME then
            return false
        end
    end

    return true
end




local function getWrappedItem(groundItemEnt)
    local inv = groundItemEnt.inventory
    local w,h = inv.width, inv.height
    assert(w == 1 and h == 1, "?")
    -- the wrapped item will always be at slot 1,1
    return inv:get(w,h) 
end




local function tryPickUp(ent, picked)
    local best_ent -- the best ground ent to pick up
    local best_dist = math.huge

    for _, groundEnt in groundItemPartition:iterator(ent.x, ent.y) do
        --[[
            `groundEnt` has a 1x1 inventory, holding an item entity.
            We want to pick up that item.   
        ]]
        local item = getWrappedItem(groundEnt)
        if (not picked[groundEnt]) then 
            -- then the item is on the ground
            local dist = math.distance(ent, groundEnt)
            if canBePickedUp(dist, groundEnt) and dist < best_dist then
                -- always pick up the closest item.
                if ent.inventory:findAvailableSlot(item) then
                    best_dist = dist
                    best_ent = groundEnt
                end
            end
        end
    end

    if best_ent then
        -- pick up this groundItem
        local item = getWrappedItem(best_ent)
        best_ent.inventory:move(1,1, ent.inventory)
        umg.call("pickupGroundItem", ent, item)
        -- delete the item on ground
        best_ent:delete()
    end
end



local function updatePartition()
    for _, ent in ipairs(groundItemGroup) do
        groundItemPartition:updateEntity(ent)
    end
end



local ct = 0
local LOOP_CT = 8 -- we only want to update every X ticks, for efficiency

umg.on("@tick", function(dt)
    -- This function runs once every LOOP_CT frames:
    ct = ct + 1
    if ct < LOOP_CT then
        return -- return early
    else
        ct = 0 -- else, we run function
    end
    -- ==========
    updatePartition()

    local picked = {}
    for _, ent in ipairs(pickUpGroup) do
        if ent.inventory then
            tryPickUp(ent, picked)
        end 
    end
end)


return groundItemsHandler
