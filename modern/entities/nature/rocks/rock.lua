
local IMGS = {
    "Rock3", "Rock4"
}


return {
    physics = {
        type = "static",
        shape = love.physics.newCircleShape(4)
    },

    init = function(ent, x, y)
        ent.x = x
        ent.y = y
        ent.image = table.random(IMGS)
    end
}
