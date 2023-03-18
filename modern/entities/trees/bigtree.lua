

return {
    swaying = {magnitude = 0.05},

    physics = {
        shape = love.physics.newCircleShape(8),
        type = "static"
    },

    image = "ME_Singles_Camping_16x16_Tree_157",

    oy = -38,

    init = function(ent,x,y)
        ent.x = x
        ent.y = y
    end
}


