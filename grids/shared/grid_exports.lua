

local function loadShared(grids)
    local gridsAPI = require("shared.grids")
    for k,v in pairs(gridsAPI) do
        grids[k] = v
    end

    grids.generateFloorTiling = require("shared.default_tiling.floor")
    grids.generateFenceTiling = require("shared.default_tiling.fence")
    grids.generateRoadTiling = require("shared.default_tiling.path")
end


base.defineExports("grids", {
    loadShared = loadShared
})

