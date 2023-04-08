
local LIGHT_COLOR = {1,0.9,0.9}

local DEFAULT_RADIUS = 370

return {
    init = function(e,x,y)
        e.light = {
            color = LIGHT_COLOR,
            size = DEFAULT_RADIUS
        }
        base.initializers.initXY(e,x,y)
    end
}


