

--[[

pine tree entity

]]

local PINES = {"pine4", "pine5", "pine6"}


return {
    swaying = {},

    oy = -100,

    init = function(ent,x,y)
        ent.x = x
        ent.y = y
        ent.image = table.random(PINES)
    end
}

