
local PLANT_PLACEMENT_SPACING = 5


local constants = {
    TILE_SIZE = 16;
    -- must be 16, because this is the size of the tiles in pixels

    TILE_Z_LEVEL = -10;

    GRASS_COLOR = {0,1,0};

    PLAYER_CATCH_THRESHOLD = -1000; -- player is caught at this z level
    -- change this if needed
}


constants.PLANT_PLACEMENTRULES = {
    --{type = "closeTo", category = "groundTile", distance = constants.TILE_SIZE + 10; amount = 3};
    {type = "awayFrom", category = "plant", distance = PLANT_PLACEMENT_SPACING}
};


return constants
