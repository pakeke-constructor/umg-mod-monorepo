

return {
    maxHealth = 100,
    
    bobbing = {},
    physics = {
        shape = love.physics.newCircleShape(10)
    };

    color = {.6,.6,.6};

    init = function(ent,x,y)
        base.initializers.initVxVy(ent,x,y,0,0)
        ent.health = 100
        ent.healthBar = {
            color = {math.random(), math.random(), math.random()};
            offset = 20
        }
        if math.random() < 0.5 then
            ent.image = "slant_block"
        else
            ent.image = "slant_block2"
        end
    end
}

