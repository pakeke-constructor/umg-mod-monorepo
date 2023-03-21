
return {
    image = "Rock1",

    physics = {
        type = "static",
        shape = love.physics.newCircleShape(18)
    },

    init = function(ent, x, y)
        ent.x = x
        ent.y = y
        if math.random() < 0.5 then
            ent.scaleX = -1
        end
    end
}
