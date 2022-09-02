

local MELEE_RANGE = 30
local DEFAULT_SPEED = 60


--[[
    abstract melee enemy entity

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

    "attackDamage", "attackSpeed",
    "hp", "maxHp",

    speed = DEFAULT_SPEED,

    physics = {
        shape = physics.newCircleShape(5);
        friction = 7
    };

    attackBehaviour = {
        type = "melee",
        range = MELEE_RANGE
    };

    moveBehaviour = {
        type = "follow";
        activateDistance = 1000,
    };
}

