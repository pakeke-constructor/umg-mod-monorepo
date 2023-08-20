
local LIGHT_COLOR = {1,0.9,0.9}

local DEFAULT_RADIUS = 370

return {
    initXY = true,

    init = function(e)
        e.light = {
            color = LIGHT_COLOR,
            size = DEFAULT_RADIUS
        }
    end
}


