

return {
    "x","y",
    "image",
    "growStage",

    placementCategory = {"plant"};
    init = base.initializers.initXY;

    growable = {
        time = 10;
        stages = {
            "grass_1";
            "grass_2";
            "grass_8";
            "grass_7";
            "grass_6";
        }
    };

    swaying = {};

    harvest = {
        not_grown = {
            {max = 1, min = 1, value = "grass_seed_item"};
            {max = 1, min = 0, value = "grass_item"}
        };
    
        grown = {
            {max = 2, min = 1, value = "grass_seed_item"};
            {max = 3, min = 1, value = "grass_item"}
        }
    }    
}

