

return {
    "x", "y",
    "vx", "vy",
    "color",
    image = "slant_block",
    rainbow = {},
    swaying = {},
    bobbing = {},
    physics = {
        shape = love.physics.newCircleShape(10)
    };

    health = 10,
    maxHealth = 15,

    "healthBar",

    init = function(ent,x,y)
        base.entityHelper.initPosition(ent,x,y)
        ent.healthBar = {
            color = {math.random(), math.random(), math.random()};
            offset = 20
        }
    end
}

