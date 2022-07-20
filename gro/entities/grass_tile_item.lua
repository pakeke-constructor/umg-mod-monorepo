
local constants = require("shared.constants")



return placement.newPlaceable({
    "x","y",
    "stackSize",
    "hidden",
    maxStackSize = 20;
    image="grass_tile_item";
    itemName = "grass_tile_item";
    itemHoldImage = "grass_tile_item";

    placeGridSize = constants.TILE_SIZE;

    placementRules = {
        {type = "awayFrom", category = "groundTile", distance = constants.TILE_SIZE - 1} 
        -- we should give some leighway with the distance; 1 pixel should be fine.
        -- This placementRule ensures that ground tiles can't be stacked on top of each other.
    };
   
    itemHoldType = "place";

    spawn = function(x,y)
        if server then
            local e = entities.grass_tile()
            e.x = x
            e.y = y
        else
            base.shockwave(x,y,5,50,5,0.5)
        end
    end
})
