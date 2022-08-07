
return {
    "x","y",
    "image",
    "growStage",

    placementCategory = {"plant"};
    init = base.entityHelper.initPosition;

    growable = {
        time = 300;
        stages = {
            "corn_1";
            "corn_2";
            "corn_3"
        }
    };

    swaying = {};

    harvest = {
        not_grown = {
            {max = 1, min = 1, value = "corn_seed_item"}
        };
    
        grown = {
            {max = 2, min = 1, value = "corn_seed_item"};
            {max = 3, min = 1, value = "corn_item"}
        }
    }    
}

