

local MELEE_RANGE = 30
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
        range = MELEE_RANGE
    };

    moveBehaviour = {
        type = "follow";
        activateDistance = 1000,
    };
}

