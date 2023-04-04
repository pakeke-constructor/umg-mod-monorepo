

local MELEE_RANGE = 30
local DEFAULT_SPEED = 60


--[[
    abstract melee enemy entity

    entities that extend this will inherit these components:
]]
return {
    speed = DEFAULT_SPEED,

    physics = {
        shape = love.physics.newCircleShape(5);
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

