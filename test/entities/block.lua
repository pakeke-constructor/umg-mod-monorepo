

return {
    "x", "y",
    "vx", "vy",
    "image",
    bobbing = {},
    physics = {
        shape = physics.newCircleShape(10)
    };
    color = {.6,.6,.6};

    health = 10,
    maxHealth = 15,

    "healthBar",

    init = function(ent)
        ent.healthBar = {
            color = {math.random(), math.random(), math.random()};
            offset = 20
        }
    end
}

