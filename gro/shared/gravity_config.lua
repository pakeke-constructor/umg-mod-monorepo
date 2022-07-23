

local constants = require("shared.constants")

local TILE_SIZE = constants.TILE_SIZE
local PARTITION_SIZE = TILE_SIZE * 2

local tilePartition = base.Partition(PARTITION_SIZE, PARTITION_SIZE)



local tileGroup = group("groundTile", "x", "y")


tileGroup:onAdded(function(ent)
    tilePartition:add(ent)
end)

tileGroup:onRemoved(function(ent)
    tilePartition:remove(ent)
end)





base.gravity.setGroundTest(function(ent)
    --  TODO: Spatial partition iteration is very slow, fix it,
    -- use lua iterators properly instead of creating tables
    for gtile in tilePartition:iter(ent.x, ent.y) do
        local dist = math.distance(gtile.x - ent.x, gtile.y - ent.y)
        if dist <= TILE_SIZE and ent.z > -10 then
            return true
        end
    end
    return false -- its not above a ground tile; indicate that its in the air.
end)

