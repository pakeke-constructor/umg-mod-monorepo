
local droppedItemGroup = umg.group("itemBeingHeld")


local itemDrops = {}



local PICKUP_DISTANCE = 15
itemDrops.PICKUP_DISTANCE = PICKUP_DISTANCE
-- distance from when you can pick up an item



local PICKUP_DELAY_TIME = 2 --- 2 seconds delay is reasonable
itemDrops.PICKUP_DELAY_TIME = PICKUP_DELAY_TIME



if server then
itemDrops.itemPartition = base.Partition(
    PICKUP_DISTANCE + 5
)
end



function itemDrops.dropItem(item, x, y)
    --[[
        signals for an item entity to be dropped on the ground
    ]]
    item.x = (x or item.x) or 0
    item.y = (y or item.y) or 0

    -- TODO: 
    -- Remove shitty ephemeral component usage here
    item._item_last_holdtime = love.timer.getTime() -- ephemeral component,
    -- (keeps track of the last time this item was held)

    item.hidden = false
    item.itemBeingHeld = false
    itemDrops.itemPartition:addEntity(item)

    server.broadcast("dropInventoryItem", item, item.x, item.y)
end



function itemDrops.pickupItem(item)
    --[[
        signals for an item entity to be picked up
    ]]
    itemDrops.itemPartition:removeEntity(item)
    server.broadcast("pickUpInventoryItem", item)
    item._item_last_holdtime = nil
    item.hidden = true
    item.itemBeingHeld = true
end






function itemDrops.canBePickedUp(dist, best_dist, item)
    local bool2 = (dist < itemDrops.INTERACTION_DISTANCE) and (dist < best_dist)
    if not bool2 then return end

    if item._item_last_holdtime then
        local time = love.timer.getTime() - item._item_last_holdtime
        if time < PICKUP_DELAY_TIME then
            return
        end
    end

    return true
end



return itemDrops

