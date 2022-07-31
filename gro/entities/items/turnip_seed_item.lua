
local constants = require("shared.constants")


return placement.newPlaceable({
    "x","y",
    "stackSize",
    "hidden",

    maxStackSize = 99;
    image="turnip_seed_item";
    itemName = "turnip_seed";
    itemHoldImage = "turnip_1";

    placementRules = constants.PLANT_PLACEMENTRULES;

    itemHoldType = "place";

    spawn = function(x,y)
        print("spawn grass:", x, y)
        entities.grass(x,y)
    end
})

