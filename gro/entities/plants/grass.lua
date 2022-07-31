

return {
    "x","y",

    image = "grass_1",
    placementCategories = {"plant"};
    init = base.entityHelper.initPosition;

    growable = {
        time = 30;
        stages = {
            "grass_1";
            "grass_2";
            "grass_8";
            "grass_7";
            "grass_6";
        }
    };

    harvest = {
        not_grown = {
            {max = 1, min = 1, value = "grass_seed_item"};
            {max = 1, min = 0, value = "flax_item"}
        };
    
        grown = {
            {max = 2, min = 1, value = "grass_seed_item"};
            {max = 3, min = 1, value = "flax_item"}
        }
    }    
}

