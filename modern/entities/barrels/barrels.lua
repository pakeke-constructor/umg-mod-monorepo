

local IMGS = {
    "ME_Singles_City_Props_16x16_Barrel_3",
    "ME_Singles_City_Props_16x16_Barrel_4",
    "ME_Singles_City_Props_16x16_Barrel_12",    
}

return {
    maxHealth = 100,
        
    physics = {
        type = "static",
        shape = love.physics.newCircleShape(13)
    };

    initXY = true,

    init = function(ent,x,y)
        ent.image = table.random(IMGS)
    end
}

