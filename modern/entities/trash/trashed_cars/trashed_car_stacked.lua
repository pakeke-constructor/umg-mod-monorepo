

local IMGS = {
    "ME_Singles_City_Props_16x16_Car_Wreck_4",
    "ME_Singles_City_Props_16x16_Car_Wreck_5",
    "ME_Singles_City_Props_16x16_Car_Wreck_6",
}


return {
    physics = {
        type = "static",
        shape = love.physics.newRectangleShape(56, 24)
    },

    oy = -14,

    init = function(ent, x, y)
        ent.x = x
        ent.y = y
        ent.image = table.pick_random(IMGS)
    end
}
