

local RANGE = 300
local DEFAULT_SPEED = 60


--[[
    abstract melee entity

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
    "hp", "maxHp",

    speed = DEFAULT_SPEED,

    attackBehaviour = {
        type = "melee",
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
}

