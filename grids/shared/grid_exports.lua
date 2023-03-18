

local function loadShared(grids)
    local gridsAPI = require("shared.grids")
    for k,v in pairs(gridsAPI) do
        grids[k] = v
    end

    grids.generateFloorTiling = require("shared.default_tilings.floor")
    grids.generateFenceTiling = require("shared.default_tilings.fence")
    grids.generatePathTiling = require("shared.default_tilings.path")
end


base.defineExports({
    name = "grids",
    loadShared = loadShared
})

