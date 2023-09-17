
--[[

Entities that can pick up items off the ground have a `canPickUpItems` component.

]]

local constants = require("shared.constants")

local groundItems = {}



local pickUpGroup = umg.group("x", "y", "canPickUpItems", "inventory")

local groundItemGroup = umg.group("x", "y", "groundItem")




local PICKUP_DISTANCE = constants.PICKUP_DISTANCE
local CHUNK_SIZE = PICKUP_DISTANCE

local groundItemPartition = dimensions.DimensionPartition(CHUNK_SIZE)



-- Wait X seconds before being able to pick up dropped items.
-- this way, when an item is dropped on the ground, it isn't instantly picked up.
local PICKUP_DELAY_TIME = 4




local function dropItem(itemEnt, dvec)
    itemEnt.x = dvec.x
    itemEnt.y = dvec.y
    itemEnt.dimension = dimensions.getDimension(dvec.dimension)
    itemEnt.groundItem = true

    umg.call("items:dropGroundItem", itemEnt)
end



local function pickUpItem(item, pickupEnt)
    item:removeComponent("x")
    item:removeComponent("y")
    item:removeComponent("dimension")
    item:removeComponent("groundItem")

    umg.call("items:pickupGroundItem", item, pickupEnt)
end





local dropItemTc = typecheck.assert("voidentity", "dvector")

function groundItems.drop(itemEnt, dvec)
    dropItemTc(itemEnt, dvec)
    dropItem(itemEnt, dvec)
end



groundItemGroup:onAdded(function(e)
    groundItemPartition:addEntity(e)
    e.groundItemSpawnTime = state.getGameTime()
end)


groundItemGroup:onRemoved(function(e)
    groundItemPartition:removeEntity(e)
end)




local function canBePickedUp(dist, item)
    if dist > PICKUP_DISTANCE then 
        return false
    end

    if item.groundItemSpawnTime then
        local time = state.getGameTime() - item.groundItemSpawnTime
        if time < PICKUP_DELAY_TIME then
            return false
        end
    end

    return true
end



local function tryPickUp(ent, picked)
    --[[
        `ent` is the entity trying to pick up items
    ]]
    local best_ent -- the best ground ent to pick up
    local slotX, slotY
    local best_dist = math.huge

    for _, item in groundItemPartition:iterator(ent) do
        --[[
            `groundEnt` has a 1x1 inventory, holding an item entity.
            We want to pick up that item.   
        ]]
        if (not picked[item]) then 
            -- then the item is on the ground
            local dist = math.distance(ent, item)
            if canBePickedUp(dist, item) and dist < best_dist then
                -- always pick up the closest item.
                local sx, sy = ent.inventory:findAvailableSlot(item)
                if sx then
                    -- if there is a slot for this item, mark it
                    slotX, slotY = sx, sy
                    best_dist = dist
                    best_ent = item
                end
            end
        end
    end

    if best_ent then
        -- pick up this groundItem
        local success = ent.inventory:tryAddToSlot(slotX, slotY, best_ent)
        if success then
            -- realistically, `success` should always be true, (since we used findAvailableSlot)
            -- but its better to be safe than sorry
            picked[best_ent] = true
            pickUpItem(best_ent, ent)
        end
    end
end



local function updatePartition()
    for _, ent in ipairs(groundItemGroup) do
        groundItemPartition:updateEntity(ent)
    end
end


umg.on("dimensions:dimensionDestroyed", function(dim)
    groundItemPartition:destroyDimension(dim)
end)



local LOOP_CT = 8 -- we only want to update every X ticks, for efficiency

scheduling.runEvery(LOOP_CT, "@tick", function(dt)
    -- Only run every X frames
    updatePartition()

    local picked = {}
    for _, ent in ipairs(pickUpGroup) do
        if ent.inventory then
            tryPickUp(ent, picked)
        end 
    end
end)


return groundItems
