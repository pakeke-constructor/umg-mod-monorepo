


local chunkAPI = require("shared.chunks")


local function loadShared(chunks)
    chunks.ChunkRegistry = chunkAPI.ChunkRegistry
    chunks.forEach = chunkAPI.forEach
end


base.defineExports({
    name = "chunks",

    loadShared = loadShared
})

