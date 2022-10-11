

local terrainIds = require("terrain_ids")


on("mainDraw", function()
    for _, terrain in ipairs(terrainIds.getTerrainObjects().objects) do
        -- TODO:: do this properly,
        -- making sure draworder is correct.
        -- You may need to use `drawIndex`.
        terrain:draw()
    end
end)


