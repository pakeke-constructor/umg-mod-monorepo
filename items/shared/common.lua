

local common = {}



local PICKUP_DISTANCE = 15
common.PICKUP_DISTANCE = PICKUP_DISTANCE
-- distance from when you can pick up an item



local PICKUP_DELAY_TIME = 2 --- 2 seconds delay is reasonable
common.PICKUP_DELAY_TIME = PICKUP_DELAY_TIME



if server then
common.itemPartition = base.Partition(
    PICKUP_DISTANCE + 5, PICKUP_DISTANCE + 5
)
end



function common.dropItem(item, x, y)
    --[[
        signals for an item entity to be dropped on the ground
    ]]
    if client then
        error("This shouldn't be called on clientside")
    end
    item.x = (x or item.x) or 0
    item.y = (y or item.y) or 0
    item._item_last_holdtime = love.timer.getTime() -- ephemeral component
    -- (keeps track of the last time this item was held)

    item.hidden = false
    item.itemBeingHeld = false
    common.itemPartition:add(item)

    server.broadcast("dropInventoryItem", item, x, y)
end



function common.pickupItem(item)
    --[[
        signals for an item entity to be picked up
    ]]
    if client then
        error("This shouldn't be called on clientside")
    end

    common.itemPartition:remove(item)
    server.broadcast("pickUpInventoryItem", item)
    item._item_last_holdtime = nil
    item.hidden = true
    item.itemBeingHeld = true
end






function common.canBePickedUp(dist, best_dist, item)
    if client then
        return false -- the server must be in charge of pickups
    end
    local bool2 = (dist < common.INTERACTION_DISTANCE) and (dist < best_dist)
    if not bool2 then return end

    if item._item_last_holdtime then
        local time = love.timer.getTime() - item._item_last_holdtime
        if time < PICKUP_DELAY_TIME then
            return
        end
    end

    return true
end



return common

