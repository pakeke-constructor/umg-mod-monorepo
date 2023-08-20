
local SIZE = 400

return {
    draw = true,
    cyanZone = true,
    drawDepth = -SIZE,
    size = SIZE,
    onDraw = function(ent)
        love.graphics.setLineWidth(5)
        love.graphics.setColor(0,1,1)
        love.graphics.circle("line", ent.x, ent.y, SIZE)
    end,
    
    initXY = true
}

