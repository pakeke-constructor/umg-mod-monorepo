

local SHAPE = love.physics.newCircleShape(1)


return {
    rotateOnMovement = true,
    image = "bullet",

    projectile = {
        damage = 30
    },

    physics = {
        friction = 0,
        shape = SHAPE,
        mass = 0.01,
        type = "kinematic"
    },

    light = {}
}

