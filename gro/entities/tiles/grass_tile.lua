

local constants = require("shared.constants")


return {
    "x", "y", "image",
    z = constants.TILE_Z_LEVEL,

    color = {0,1,0,0.2};--constants.GRASS_COLOR;

    groundTile = true, -- TODO: Change this up maybe?
    -- we should be able to put more important info in here.
    -- Like, maybe contains what can be planted?

    placementCategory = {
        "plantTile"
    };

    init = function(e, x, y)
        local r = math.random()
        if r < 0.3 then
            e.image = "grass_tile2"
        elseif r < 0.6 then
            e.image = "grass_tile1"
        else
            e.image = "grass_tile3"
        end
        e.x = x
        e.y = y
    end
}

