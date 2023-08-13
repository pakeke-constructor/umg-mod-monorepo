
--[[
    
Spatial partition object, counting x,y,dimension values.

Unlike regular Partitions,
entities are separated by dimensions AND x,y values.


]]

local getDimension = require("shared.get_dimension")



local Partition = objects.Partition


local DimensionPartition = objects.Class("dimensions:DimensionPartition")



local initTc = typecheck.assert("number")

function DimensionPartition:init(chunkSize)
    initTc(chunkSize)
    self.chunkSize = chunkSize

    self.dimensionToPartition = {--[[
        [dimension] --> Partition
    ]]}

    self.entityToDimension = {--[[
        [entity] -> dimension
    ]]}
end



function DimensionPartition:removeEmptyChunks()
    for _, partition in pairs(self.dimensionToPartition) do
        partition:removeEmptyChunks()
    end
end



function getPartition(self, dimension)
    if self.dimensionToPartition[dimension] then
        return self.dimensionToPartition[dimension]
    end

    local partition = Partition(self.chunkSize)
    self.dimensionToPartition[dimension] = partition
    return partition
end



local function addEntity(self, ent)
    local dim = getDimension(ent)
    self.entityToDimension[ent] = dim
    local partition = getPartition(self, dim)
    partition:addEntity(ent)
end



local function removeEntity(self, ent)
    local dim = self.entityToDimension[ent]
    self.entityToDimension[ent] = nil
    local partition = getPartition(self, dim)
    partition:removeEntity(ent)
end






--[[
    call this whenever a dimension gets destroyed
    (:dimensionDestroyed event)
]]
function DimensionPartition:destroyDimension(dimension)
    self.dimensionToPartition[dimension] = nil
end




--[[
    moves an entity into a different chunk if required
]]
function DimensionPartition:updateEntity(ent)
    local lastDim = self.entityToDimension[ent]
    local dim = getDimension(ent)
    assert(lastDim, "?")
    
    if lastDim ~= dim then
        -- then the entity has changed dimensions
        removeEntity(self, ent)
        addEntity(self, ent)
    else
        -- the entity hasn't changed dimensions,
        -- so update within existing dimension partition.
        local partition = getPartition(self, dim)
        partition:updateEntity(ent)
    end
end



--[[
:addEntity and :removeEntity need to be executed atomically,
i.e. between frames.

Tagging onto group's onRemoved and onAdded is what should be done in the ideal case.
]]
function DimensionPartition:addEntity(ent)
    addEntity(self, ent)
end


function DimensionPartition:removeEntity(ent)
    removeEntity(self, ent)
end







local forEachAssert = typecheck.assert("dvector", "function")

function DimensionPartition:forEach(dVec, func)
    forEachAssert(dVec, func)
    local dim = getDimension(dVec)

    if rawget(self.dimensionToPartition, dim) then
        local partition = self.dimensionToPartition[dim]
        return partition:forEach(dVec.x, dVec.y, func)
    end
end




function DimensionPartition:contains(ent)
    return self.entToDimension[ent]
end




local EMPTY = {}

local iteratorTc = typecheck.assert("table", "dvector")

function DimensionPartition:iterator(dVec)
    iteratorTc(dVec)
    local dim = getDimension(dVec)

    if rawget(self.dimensionToPartition, dim) then
        local partition = self.dimensionToPartition[dim]
        return partition:iterator(dVec.x, dVec.y)
    end
    return ipairs(EMPTY)
end



return Partition
