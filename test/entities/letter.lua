

return {
    
    bobbing = {},
    physics = {
        shape = love.physics.newCircleShape(10)
    };

    --color = {0.8,0.8,0.8};

    init = function(ent,x,y,img)
        assert(img,"?")
        ent.image = img
    end,

    initVxVy = true
}

