

local IMGS = {
    "ME_Singles_Shopping_Center_and_Markets_16x16_Market_Big_2",
    "ME_Singles_Shopping_Center_and_Markets_16x16_Market_Big_3",
}

local W, H = 112, 170

return {
    physics = {
        shape = love.physics.newRectangleShape(W,H)
    },

    drawDepth = 80,

    init = function(ent,x,y)
        ent.x = x
        ent.y = y
        ent.image = table.pick_random(IMGS)
    end
}

