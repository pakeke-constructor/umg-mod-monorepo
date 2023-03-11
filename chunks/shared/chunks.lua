

local constants = require("shared.constants")

local ChunkRegistry = require("shared.chunk_registry")



--[[
    This is the "main" chunk,
    i.e. a chunk of all entities that exist in the game
]]
local globalChunkRegistry = ChunkRegistry(constants.CHUNK_SIZE)



local moveGroup = umg.group("x", "y", "vx", "vy")

local positionGroup = umg.group("x", "y")


positionGroup:onAdded(function(ent)
    globalChunkRegistry:addEntity(ent)
end)


positionGroup:onRemoved(function(ent)
    globalChunkRegistry:removeEntity(ent)
end)



umg.on("@tick", function()
    for _, ent in ipairs(moveGroup) do
        globalChunkRegistry:updateEnt(ent)
    end
end)




local chunks = {}


chunks.ChunkRegistry = ChunkRegistry


function chunks.forEach(x, y, func)
    return globalChunkRegistry:forEach(x,y,func)
end

return chunks

