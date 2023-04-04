
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

    init = function(ent, x, y)
        ent.x = x
        ent.y = y

        ent.particles = {
            type = "circle",
            rate = 20
        }
    end
}

