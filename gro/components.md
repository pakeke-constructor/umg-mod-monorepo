
```lua


buildable = {
    onBuild = function(ent)
        -- Called when entity is built
    end;

    onDemolish = function(ent)
        -- Called when entity is demolished
    end;

    canBuild = function(ent, x, y)
        -- returns true/false, whether the entity can be built at 
        -- the specified location.
    end;
}


built = true/false -- Whether an entity is built or not.
-- For example, buildable items in the inventory will have `built=false`, because
-- they aren't built; they are in the inventory



grid



```


