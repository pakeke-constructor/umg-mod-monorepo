

--[[

If a player is close enough to an item, the item will
be picked up.

I.e, the entity needs `controllable` and `inventory` component to pick up
stuff.


]]



local invPlayers = group("x", "y", "controllable", "inventory")

local items = group("x", "y", "itemName")

local partition = require("_libs.spatial_partition.partition")

local itemPartition = partition(20,20)




items:on_added(function(e)
    itemPartition:add(e)
end)

items:on_removed(function(e)
    itemPartition:remove(e)
end)


local INTERACTION_DISTANCE = 15
-- distance from when you can pick up an item


on("update5", function(dt)
    local seen = {}
    itemPartition:update(dt)
    for _, player in ipairs(invPlayers) do
        local best_dist = math.huge
        local pickup
        local ix, iy = player.inventory:getFreeSpace()
        if ix then
            for item in itemPartition:foreach(player.x, player.y) do
                local d = math.distance(player, item)
                if not seen[item] and not item.hidden and d < INTERACTION_DISTANCE and d < best_dist then
                    pickup = item
                end
            end
        end
        if pickup then
            player.inventory:set(ix, iy, pickup)
            print(ix, iy)
            server.broadcast("pickUpInventoryItem", pickup)
            seen[pickup] = true
            pickup.hidden = true -- hidden items means that it's inside an inventory
        end
    end
end)


