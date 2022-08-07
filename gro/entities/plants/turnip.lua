
return {
    "x","y",
    "image",
    "growStage",

    placementCategory = {"plant"};
    init = base.entityHelper.initPosition;

    growable = {
        time = 300;
        stages = {
            "turnip_1";
            "turnip_2";
            "turnip_3"
        }
    };

    swaying = {};

    harvest = {
        not_grown = {
            {max = 1, min = 1, value = "turnip_seed_item"}
        };
    
        grown = {
            {max = 2, min = 1, value = "turnip_seed_item"};
            {max = 3, min = 1, value = "turnip_item"}
        }
    }    
}

