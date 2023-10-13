

local defaultColor = {0,0,0,0.6}

local prio = 10

umg.on("rendering:drawEntity", function(ent)
    if ent.shadow and ent.image then
        local r,b,g,a = love.graphics.getColor()
        local size = ent.shadow.size
        local oy = size + (ent.shadow.oy or 0)
        love.graphics.setColor(ent.shadow.color or defaultColor)
        love.graphics.circle("fill", ent.x, ent.y + oy, size)
        love.graphics.setColor(r,b,g,a)
    end
end, prio)

