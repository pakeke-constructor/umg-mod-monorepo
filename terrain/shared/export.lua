


local function loadShared(terrain)
    terrain.Terrain = require("terrain")
end





base.defineExports({
    name = "terrain",
    loadShared = loadShared,
    
})

