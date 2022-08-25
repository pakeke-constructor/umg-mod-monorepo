
```lua
--[[
    callbacks for when an entity gets in range of this entity.
]]
ent.proximity = {
    targetCategory = "enemy",
    range = 100,

    update = function(ent, target_ent)
        -- called every frame whilst in range 
        -- of any entity inside the "enemy" category.
    end, 

    exit = function(ent, target_ent)
        -- called once when there are no longer any target entities in range.
        --`target_ent` is the last target entity in range.
    end,

    enter = function(ent, target_ent)
        -- called once when a target entity comes in range.
        -- If there is already an entity in range, this won't be called.
    end
}



-- Override for proximity target.
ent.proximityTargetCategory = "enemy",
-- The proximity system will check this value first, 
-- and then fall back to ent.proximity.targetCategory if this is nil.
-- (Useful for stuff like changing teams, etc.)

-- override for a specific entity.
ent.proximityTargetEntity = enemy_ent


```


