

local PINES = {
    "ME_Singles_Camping_16x16_Tree_206",
    "ME_Singles_Camping_16x16_Tree_212",
}


return {
    swaying = {magnitude = 0.1},

    physics = {
        shape = love.physics.newCircleShape(8),
        type = "static"
    },

    oy = -16,

    init = function(ent,x,y)
        ent.x = x
        ent.y = y
        ent.image = table.pick_random(PINES)
    end
}


