

local IMGS = {
    "ME_Singles_Generic_Building_16x16_Condo_5_2",
    "ME_Singles_Generic_Building_16x16_Condo_5_1",
    "ME_Singles_Generic_Building_16x16_Condo_5_3"
}

local W, H = 96, 144

return {
    physics = {
        shape = love.physics.newRectangleShape(W,H)
    },

    drawDepth = 70,

    init = function(ent,x,y)
        ent.x = x
        ent.y = y
        ent.image = table.pick_random(IMGS)
    end
}

