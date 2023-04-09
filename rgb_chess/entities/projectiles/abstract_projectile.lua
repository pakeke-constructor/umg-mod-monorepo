
--[[

Projectile entity

Projectiles can be shot by unit entities,
OR by item entities.

]]


local constants = require("shared.constants")

return {
    speed = constants.PROJECTILE_SPEED,
    image = "bullet",

    moveRotation = {};

    moveBehaviour = {
        type = "follow",
        stopDistance = 0
    },

    rgbProjectile = true,
    
    superInit = function(ent, x, y, options)
        --[[
            options = {
                projectileType = constants.PROJECTILE_TYPES.*,
                targetEntity = <target>
                sourceEntity = <source ent>
                ...
            }
        ]]
        base.initializers.initVxVy(ent,x,y)

        assert(options and type(options) == "table", "Not given options table")
        assert(umg.exists(options.targetEntity), "Not given a targetEntity") 

        for k,v in pairs(options)do
            ent[k] = v
        end

        ent.moveBehaviourTargetEntity = options.targetEntity
        ent.rgbProjectileTargetEntity = options.targetEntity
    end
}

