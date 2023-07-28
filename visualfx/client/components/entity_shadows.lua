

local defaultColor = {0,0,0,0.6}

umg.on("preDrawEntity", function(ent)
    if ent.shadow and ent.image then
        local r,b,g,a = love.graphics.getColor()
        local size = ent.shadow.size
        love.graphics.setColor(ent.shadow.color or defaultColor)
        love.graphics.circle("fill", ent.x, ent.y + size, size)
        love.graphics.setColor(r,b,g,a)
    end
end)

