

```lua

ent.growStage = 0.65 -- the current growStage the entity is at
-- (a floating point number from 0 to 1)


-- this entity grows bigger via changing images:
ent.growable = {
    time = 150; -- total time in seconds to grow
    -- (plus or minus 10%)
    
    stages = {
        "grass_1";
        "grass_2";
        "grass_8";
        "grass_7";
        "grass_6";
    }
}


-- however, this entity grows bigger via image scaling:
-- (Useful for stuff like giant pine trees, or giant mushrooms.)
ent.growable = {
    time = 150; -- total time in seconds to grow
        -- (plus or minus 10%)

    minScale = 0.1;
    maxScale = 1; -- grows 10% more or 10% less than this.
}



-- crop yields from harvest:
ent.harvest = {
    not_grown = {
        {max = 1, min = 1, value = "grass_seed_item"};
        {max = 1, min = 0, value = "flax_item"}
    };

    grown = {
        {max = 2, min = 1, value = "grass_seed_item"};
        {max = 3, min = 1, value = "flax_item"}
    }
}



```
