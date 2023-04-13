

local IMGS = {
    "ME_Singles_Camping_16x16_Tree_97",
    "ME_Singles_Camping_16x16_Tree_100",
}


return {
    swaying = {magnitude = 0.03},

    physics = {
        shape = love.physics.newCircleShape(8),
        type = "static"
    },

    oy = -32,

    init = function(ent,x,y)
        ent.x = x
        ent.y = y
        ent.image = table.random(IMGS)
    end
}


