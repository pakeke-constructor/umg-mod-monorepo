

local IMGS = {
    "ME_Singles_Shopping_Center_and_Markets_16x16_Market_Medium_4",
    "ME_Singles_Shopping_Center_and_Markets_16x16_Market_Medium_5",
}

local W, H = 112, 122

return {
    physics = {
        shape = love.physics.newRectangleShape(W,H)
    },

    drawDepth = 60,

    init = function(ent,x,y)
        ent.x = x
        ent.y = y
        ent.image = table.pick_random(IMGS)
    end
}

