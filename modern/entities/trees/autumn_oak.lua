
local IMGS = {
    "ME_Singles_Camping_16x16_Tree_11",
    "ME_Singles_Camping_16x16_Tree_20",
    "ME_Singles_Camping_16x16_Tree_32"
}


return {
    swaying = {magnitude = 0.15},

    physics = {
        shape = love.physics.newCircleShape(4),
        type = "static"
    },

    oy = -8,

    init = function(ent,x,y)
        ent.x = x
        ent.y = y
        ent.image = table.pick_random(IMGS)
    end
}


