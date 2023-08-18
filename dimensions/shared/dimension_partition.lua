
--[[
    
Spatial partition object, counting x,y,dimension values.

Unlike regular Partitions,
entities are separated by dimensions AND x,y values.


]]


require("shared.dimension_vector") -- we need typecheck defs

local getDimension = require("shared.get_dimension")


local Partition = objects.Partition
local DimensionObject = require("shared.dimension_object")

local DimensionPartition = objects.Class("dimensions:DimensionPartition", DimensionObject)



local initTc = typecheck.assert("number")

function DimensionPartition:init(chunkSize)
    initTc(chunkSize)
    self:super()
    self.chunkSize = chunkSize
end



--[[
==========================
    OVERRIDES:
]]
function DimensionPartition:addEntityToObject(partition, ent)
    partition:addEntity(ent)
end

function DimensionPartition:removeEntityFromObject(partition, ent)
    partition:removeEntity(ent)
end

function DimensionPartition:newObject()
    return Partition(self.chunkSize)
end
--[[
    END OF OVERRIDES.
==========================
]]










function DimensionPartition:removeEmptyChunks()
    for _, partition in pairs(self.dimensionToObject) do
        partition:removeEmptyChunks()
    end
end



function DimensionPartition:updateEntity(ent)
    local partition = self:getObjectForEntity(ent)
    partition:updateEntity(ent)
end





local forEachAssert = typecheck.assert("dvector", "function")

function DimensionPartition:forEach(dVec, func)
    forEachAssert(dVec, func)
    local dim = getDimension(dVec)

    if self:hasDimension(dim) then
        local partition = self:getObject(dim)
        return partition:forEach(dVec.x, dVec.y, func)
    end
end




local EMPTY = {}

local iteratorTc = typecheck.assert("table", "dvector")

function DimensionPartition:iterator(dVec)
    iteratorTc(self, dVec)
    local dim = getDimension(dVec)

    if self:hasDimension(dim) then
        local partition = self:getObject(dim)
        return partition:iterator(dVec.x, dVec.y)
    end
    return ipairs(EMPTY)
end



return DimensionPartition
