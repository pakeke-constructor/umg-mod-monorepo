

# attack behaviour mod:

```lua


--[[
===============

Attacking entities:

=======
]]
ent.attackSpeed = 1 -- how long it takes to do an attack.

ent.attackDamage = 10 -- the damage dealt per attack.


local ATTACK_TYPES = {
    "melee", -- melee attack
    "ranged", -- ranged attack
    "item" -- using an item (must be holding an item)
}


ent.attackBehaviour = {
    type = anything from ATTACK_TYPES,
    range = 10, -- range of attack

    target = "player", -- targets player entities (entities in `player` category.)

    -- OPTIONAL VALUES:
    
    -- splash damage:
    -- (Works with both ranged and melee)
    splash = {
        radius = 5, -- radius of splash damage
        shockwave = true/false -- whether to emit a shockwave or not
        damageFalloff = "linear" or "quadratic" -- damage falloff.
        -- if damageFalloff is nil, there is no damage falloff.
    }

    -- ranged:
    projectile = "entity_name",
    fireProjectile = function(ent, targ)
        ... -- OPTIONAL:
        --  callback for custom projectile stuff.
        -- This is called whenever a projectile is fired.
    end
    projectileCount = 1, -- default of 1
    projectileSpeed = 100, -- default of X
}


ent.attackBehaviourTargetCategory = "neutral"
-- This is an override for `ent.attackBehaviour.target`.


ent.attackBehaviourTargetEntity = ent_1
-- override to allow attackBehaviour to target one specific entity.





--[[
====================
projectiles:
==================

Projectiles are entities.
They must have an `x`, `y`, and `attackBehaviourProjectile` component.

]]

local proj_ent = {
    "x","y",
    "attackBehaviourProjectile"
}
proj_ent.attackBehaviourProjectile = {
    target_ent = target_ent;
    target_x = target_ent.x;
    target_y = target_ent.y;
    projector_ent = projecting_ent
}
```



