

local constants = require("shared.constants")


return {
    "x", "y",
    z = -10,

    image = "grass_tile1";

    color = constants.GRASS_COLOR;

    groundTile = true, -- TODO: Change this up maybe?
    -- we should be able to put more important info in here.
    -- Like, maybe contains what can be planted?

    placementCategories = {
        "groundTile"
    }
}
