


local RANGE = 300
local DEFAULT_SPEED = 60


--[[
    abstract ranged entity

    entities that extend this will inherit these components:
]]
return {
    speed = DEFAULT_SPEED,

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
        type = "circle";
        activateDistance = 1000,

        circleRadius = RANGE - 10,
        circlePeriod = 100,
    };
}

