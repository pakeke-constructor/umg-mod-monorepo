
--[[

This file gets and caches the offsets for LOVE2d Quads in an efficient manner.


Offsets in X will always be     width_of_quad / 2
Offsets in Y will always be     height_of_quad / 2

]]


local quad_to_ox
quad_to_ox = setmetatable({}, {
    -- quadname -> offset x
    __index = function(_,quad)
        local _,_, w, _ = quad:getViewport()
        quad_to_ox[quad] = w / 2
        return w/2
    end
})

local quad_to_oy
quad_to_oy = setmetatable({}, {
    -- quadname -> offset y
    __index = function(_,quad)
        local _,_,_, h = quad:getViewport()
        quad_to_oy[quad] = h / 2
        return h/2
    end
})


return function(quad_or_name)
    local quad = quad_or_name
    if type(quad_or_name) == "string" then
        quad = client.assets.images[quad_or_name]
    end
    assert(quad, "base.getQuadOffsets(quad) expects a valid quad (or name) as 1st arg")
    local ox = quad_to_ox[quad]
    local oy = quad_to_oy[quad]
    return ox, oy
end

