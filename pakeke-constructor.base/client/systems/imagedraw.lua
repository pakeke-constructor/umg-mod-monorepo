

local quads = assets.quads


local quad_to_ox
quad_to_ox = setmetatable({}, {
    -- quadname -> offset x
    __index = function(_,quad)
        local _,_, w, _ = quad:getViewport()
        quad_to_ox[quad] = w / 2
    end
})

local quad_to_oy
quad_to_oy = setmetatable({}, {
    -- quadname -> offset y
    __index = function(_,quad)
        local _,_,_, h = quad:getViewport()
        quad_to_oy[quad] = h / 2
    end
})



on("drawEntity", function(ent)
    local quad = quads[ent.image]
    if not quad then
        if type(ent.image) ~= "string" then
            error(("Incorrect type for ent.image. Expected string, got: %s"):format(type(ent.image)))
        end
        error(("Unknown ent.image value: %s\nMake sure you put all images in the assets folder and name them!"):format(tostring(ent.image)))
    end

    local ox = quad_to_ox[quad]
    local oy = quad_to_oy[quad]

    local scale = ent.scale or 1
    local sx = ent.scaleX or 1
    local sy = ent.scaleY or 1
    graphics.atlas:draw(quad, ent.x, ent.y, ent.rot, sx * scale, sy * scale, ox, oy)
end)



