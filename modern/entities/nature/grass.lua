

return {
    swaying = {},

    init = function(ent, x, y)
        ent.x = x
        ent.y = y
        ent.image = "grass_" .. math.random(1,6)
    end
}
