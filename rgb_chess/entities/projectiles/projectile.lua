
--[[

Projectile entity.

Used when ranged units attack.

]]

local constants = require("shared.constants")

return {

    "x", "y",
    "vx", "vy",
    "particles",
    "attackBehaviourProjectile",

    speed = constants.PROJECTILE_SPEED,
    image = "nothing",

    color = {0.25,0.25,0.25},

    moveBehaviour = {
        type = "follow"
    },

    init = function(ent, x, y)
        ent.x = x
        ent.y = y

        ent.particles = {
            type = "circle",
            rate = 30
        }
    end
}

