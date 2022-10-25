
--[[

Entities that can pick up items off the ground have a `canPickUp` component.

]]



local pickUpEntities = group("x", "y", "canPickUp")

local itemEntities = group("x", "y", "itemName")




local currentTime = timer.getTime()


local INTERACTION_DISTANCE = 15
-- distance from when you can pick up an item


local itemPartition = base.Partition(INTERACTION_DISTANCE + 5, INTERACTION_DISTANCE + 5)




itemEntities:onAdded(function(e)
    if not e:isRegular("hidden") then
        error("Item entities must have a `hidden` regular component.\nNot the case for " .. e:type())
    end
    if not e:isRegular("itemBeingHeld") then
        error("Item entities must have a `itemBeingHeld` regular component.\nNot the case for " .. e:type())
    end
    itemPartition:add(e)
end)


itemEntities:onRemoved(function(e)
    itemPartition:remove(e)
end)



local PICKUP_DELAY_TIME = 2 --- 2 seconds delay is reasonable

local item_to_lastheldtime = {
--[[
This data structure is used to ensure that there is a delay before an item
can be picked up.

    [item] = last_held_time
]]
}


local function canBePickedUp(dist, best_dist, item)
    local bool2 = (dist < INTERACTION_DISTANCE) and (dist < best_dist)
    if not bool2 then return end

    if item_to_lastheldtime[item] then
        local time = currentTime - item_to_lastheldtime[item]
        if time < PICKUP_DELAY_TIME then
            return
        end
    end

    return true
end



local function dropInventoryItem(item, x, y)
    item.x = (x or item.x) or 0
    item.y = (y or item.y) or 0
    item_to_lastheldtime[item] = timer.getTime()
    item.hidden = false
    item.itemBeingHeld = false
    itemPartition:add(item)
end



local function canPickUpAnItem(ent)
    if not ent.canPickUp then
        return false
    end
    if ent.inventory then
        return true
    elseif ent:isRegular("holdItem") and (not exists(ent.holdItem)) then
        return true
    end
end




local function tryPickUp(ent, picked)
    local best_dist = math.huge

    local ix, iy
    local item_pickup
    local pickup_type
    for item in itemPartition:foreach(ent.x, ent.y) do
        if (not item.itemBeingHeld) and (not picked[item]) then 
            -- then the item is on the ground
            local d = math.distance(ent, item)
            if canBePickedUp(d, best_dist, item) then
                ix, iy = ent.inventory:getFreeSpace(item)
                if ix then
                    pickup_type = "inventory"
                    item_pickup = item
                    best_dist = d
                elseif ent:isRegular("holdItem") and (not exists(ent.holdItem)) and item.useItem then
                    ent.holdItem = nil -- this is just to ensure that dangling, deleted item entity references are cleaned up.
                    -- (if everything is done properly, the above line should never be needed)
                    pickup_type = "hold"
                    item_pickup = item
                    best_dist = d
                end
            end
        end
    end

    if item_pickup then
        if pickup_type == "inventory" then
            ent.inventory:set(ix, iy, item_pickup)
            server.broadcast("pickUpInventoryItem", item_pickup)
        else
            assert(pickup_type == "hold", "Bad enum value")
            ent.holdItem = item_pickup
            server.broadcast("pickUpInventoryItem", ent, item_pickup)
        end
        item_to_lastheldtime[item_pickup] = nil
        item_pickup.itemBeingHeld = true
        item_pickup.hidden = true
        picked[item_pickup] = true
    end
end




local ct = 0
local LOOP_CT = 8

on("gameUpdate", function(dt)
    -- This function runes once every LOOP_CT frames:
    ct = ct + 1
    if ct < LOOP_CT then
        return -- return early
    else
        ct = 0 -- else, we run function
    end
    -- ==========

    local picked = {}
    itemPartition:update(dt)
    for _, ent in ipairs(pickUpEntities) do
        if canPickUpAnItem(ent) then
            tryPickUp(ent, picked)
        end
    end

    for ent, _ in pairs(picked) do
        itemPartition:remove(ent)
    end
end)




return {
    dropInventoryItem = dropInventoryItem
}

