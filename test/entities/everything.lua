

return {
    image = "slant_block",
    rainbow = {},
    swaying = {},
    bobbing = {},
    physics = {
        shape = love.physics.newCircleShape(10)
    };

    health = 10,
    maxHealth = 15,

    init = function(ent,x,y)
        base.initializers.initVxVy(ent,x,y)
        ent.healthBar = {
            color = {math.random(), math.random(), math.random()};
            offset = 20
        }
    end
}

