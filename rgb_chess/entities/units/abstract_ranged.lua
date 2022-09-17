

local RANGE = 200


--[[
    abstract ranged entity

    entities that extend this will inherit these components:
]]
return {
    "x", "y",
    "vx", "vy",
    "image",
    "color",
    "category",

    "rgb",
    "rgbTeam", -- the team this entity is in
    "rgb_saveStats", -- a table for saving entity stats before combat.

    "attackDamage", "attackSpeed",
    "health", "maxHealth",
    "speed",

    "cardType",
    "squadron",

    attackBehaviour = {
        type = "ranged",
        range = RANGE,

        projectile = "projectile", -- the entity that is being shot.
        projectileCount = 1,
        fireProjectile = function(ent, targ, proj)
            proj.color = ent.color
        end
    };

    moveBehaviour = {
        type = "follow";
        activateDistance = 1000,
    };

    healthBar = {
        offset = 20,
        color = {1,0,0}
    }
}

