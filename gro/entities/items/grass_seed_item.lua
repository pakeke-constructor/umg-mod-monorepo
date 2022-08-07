
local constants = require("shared.constants")

return placement.newPlaceable({
    "x","y",
    "stackSize",
    "hidden",
    "itemBeingHeld",

    maxStackSize = 99;
    image="grass_seed_item";
    itemName = "grass_seed";
    itemHoldImage = "grass_1";
    
    placementRules = constants.PLANT_PLACEMENTRULES;

    itemHoldType = "place";

    init = base.entityHelper.initPosition;

    spawn = function(x,y) return entities.grass(x,y) end
})

