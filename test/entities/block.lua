

return {
    maxHealth = 100,
    
    bobbing = {},
    physics = {
        shape = love.physics.newCircleShape(10)
    };

    image = "block_good",

    color = {.6,.6,.6};

    init = function(ent)
        ent.health = 100
        ent.healthBar = {
            color = {math.random(), math.random(), math.random()};
            offset = 20,
            shiny = true
        }
    end,

    initVxVy = true
}

