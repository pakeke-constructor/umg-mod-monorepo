
--[[

Bullet entity;
used when ranged units attack

]]


local constants = require("shared.constants")

return {
    speed = constants.PROJECTILE_SPEED,
    image = "bullet",

    moveRotation = {};

    moveBehaviour = {
        type = "follow"
    },

    proximity = {
        targetCategory = "enemy",
        range = 100,

        enter = function(ent, target_ent)
            local shooter = ent.shooterEnt -- the entity that shot the bullet
            umg.call("rgbBulletHit", shooter, target_ent)
            base.kill(ent)
        end
    },

    init = function(ent, x, y)
        ent.x = x
        ent.y = y

        ent.particles = {
            type = "circle",
            rate = 20
        }
    end
}

