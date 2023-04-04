

local constants = require("shared.constants")


local globalChunkRegistry = chunks.ChunkRegistry(constants.CHUNK_SIZE)



local categoryMoveGroup = umg.group("x", "y", "vx", "vy", "category")

local categoryGroup = umg.group("x", "y", "category")




local categoryToChunk = {}

local function getCategoryChunk(category)
    if not categoryToChunk[category] then
        categoryToChunk[category] = chunks.ChunkRegistry(chunks.getChunkSize())
    end
    return categoryToChunk[category]
end




categoryMoveGroup:onAdded(function(ent)
    local chunks = getAllChunks(ent)
    globalChunkRegistry:addEntity(ent)
end)


categoryMoveGroup:onRemoved(function(ent)
    globalChunkRegistry:removeEntity(ent)
end)



umg.on("@tick", function()
    for _, ent in ipairs(categoryMoveGroup) do
        globalChunkRegistry:updateEnt(ent)
    end
end)


function chunks.iter(x,y)
    return globalChunkRegistry:iterate(x,y)
end


function chunks.getChunkSize()
    return constants.CHUNK_SIZE
end



