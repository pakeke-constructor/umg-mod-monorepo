

local IMGS = {
    "ME_Singles_Camping_16x16_Tree_160",
    "ME_Singles_Camping_16x16_Tree_168"
}


return {
    swaying = {magnitude = 0.05},

    physics = {
        shape = love.physics.newCircleShape(8),
        type = "static"
    },

    oy = -38,

    init = function(ent,x,y)
        ent.x = x
        ent.y = y
        ent.image = table.random(IMGS)
    end
}


