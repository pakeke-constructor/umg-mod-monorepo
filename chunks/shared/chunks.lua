

local constants = require("shared.constants")




--[[
    This is the "main" chunk,
    i.e. a chunk of all entities that exist in the game
]]
local globalChunk = data.Partition(constants.CHUNK_SIZE)



local moveGroup = umg.group("x", "y", "vx", "vy")

local positionGroup = umg.group("x", "y")


positionGroup:onAdded(function(ent)
    globalChunk:addEntity(ent)
end)


positionGroup:onRemoved(function(ent)
    globalChunk:removeEntity(ent)
end)



umg.on("@tick", function()
    for _, ent in ipairs(moveGroup) do
        globalChunk:updateEntity(ent)
    end
end)




local chunks = {}


function chunks.iterator(x,y)
    return globalChunk:iterator(x,y)
end

function chunks.getChunkSize()
    return constants.CHUNK_SIZE
end



umg.expose("chunks", chunks)

