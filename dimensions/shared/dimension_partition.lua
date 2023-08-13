
--[[
    
Spatial partition object, counting x,y,dimension values.


Each spatial partition object has a big map of chunks that
contain entities.
Think of each "chunk" as like a big bucket where entities are kept.

unlike regular Partitions,
entities are separated by dimensions AND x,y values.


]]

local getDimension = require("shared.get_dimension")



local Array = objects.Array
local Partition = objects.Partition


local DimensionPartition = objects.Class("dimensions:DimensionPartition")



function DimensionPartition:init(chunkSize)    
    self.chunks = setmetatable({--[[
        [dimension] --> Partition
    ]]})

    self.chunkList = Array()
    self.chunkSize = chunkSize

    self.entityToLastX = {--[[
        [ent] --> lastX
    ]]}
    self.entityToLastY = {--[[
        [ent] --> lastY
    ]]}
end



function Partition:getChunkIndexes(x, y)
    return math.floor(x / self.chunkSize), math.floor(y / self.chunkSize)
end


function Partition:removeEmptyChunks()
end

--[[
    moves an entity into a different chunk if required
]]
function Partition:updateEntity(ent)
end



--[[
:addEntity and :removeEntity should be executed atomically,
i.e. between frames.

Tagging onto group's onRemoved and onAdded is what should be done in the ideal case.
]]
function Partition:addEntity(ent)
end


function Partition:removeEntity(ent)
end






local forEachAssert = typecheck.assert("number", "number", "function")

function Partition:forEach(x, y, func)
end








function Partition:contains(ent)
end






function Partition:iterator(dVec)
    assertDimensionVector(dVec)
    local ix, iy = self:getChunkIndexes(x, y)
    local dx = -1
    local dy = -1

    local chunkI = 1
    local currentChunk = tryGetChunk(self,ix+dx, iy+dy)

    return function()
        if (not currentChunk) or chunkI > currentChunk:size() then
            currentChunk = nil
            while (not currentChunk) or chunkI > currentChunk:size() do
                -- We force search for a non-empty chunk
                if dx < 1 then
                    dx = dx + 1
                elseif dy < 1 then
                    dy = dy + 1
                    dx = -1
                else
                    return nil -- done iteration. Searched all chunks.
                end
                currentChunk = tryGetChunk(self,ix+dx, iy+dy)
                chunkI = 1
            end
        end

        local ent = currentChunk[chunkI]
        chunkI = chunkI + 1
        return chunkI, ent
    end
end



return Partition
