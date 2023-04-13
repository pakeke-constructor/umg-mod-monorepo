
local IMGS = {
    "ME_Singles_City_Props_16x16_Barrel_1",
    "ME_Singles_City_Props_16x16_Barrel_2",
    "ME_Singles_City_Props_16x16_Barrel_5",
    "ME_Singles_City_Props_16x16_Barrel_6",
    "ME_Singles_City_Props_16x16_Barrel_10",
    "ME_Singles_City_Props_16x16_Barrel_11"
}


return {
    maxHealth = 100,
    
    physics = {
        shape = love.physics.newCircleShape(8)
    };

    init = function(ent,x,y)
        base.initializers.initVxVy(ent,x,y)
        ent.image = table.random(IMGS)
    end
}

