
local constants = require("shared.constants")



return placement.newPlaceable({
    "x","y",
    "stackSize",
    "hidden",

    maxStackSize = 20;
    image="grass_tile_item";
    itemName = "grass_tile";
    itemHoldImage = "grass_tile_item";
    
    color = constants.GRASS_COLOR;

    placeGridSize = constants.TILE_SIZE;

    placementRules = {
        {type = "awayFrom", category = "groundTile", distance = constants.TILE_SIZE - 1} 
        -- we should give some leighway with the distance; 1 pixel should be fine.
        -- This placementRule ensures that ground tiles can't be stacked on top of each other.
    };
   
    itemHoldType = "place";

    spawn = function(x,y) return entities.grass_tile(x,y) end
})

