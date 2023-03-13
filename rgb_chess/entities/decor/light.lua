
local LIGHT_COLOR = {1,0.9,0.9}

local DEFAULT_RADIUS = 130

return {
    "x","y",
    "light",

    init = function(e,x,y, rad)
        e.light = {
            color = LIGHT_COLOR,
            size = rad or DEFAULT_RADIUS
        }
        base.entityHelper.initPosition(e,x,y)
    end
}


