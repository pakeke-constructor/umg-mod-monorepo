

local SIZE = 400

return {
    draw = true,
    yellowZone = true,
    drawDepth = -SIZE,
    size = SIZE,
    onDraw = function(ent)
        love.graphics.setLineWidth(5)
        love.graphics.setColor(1,1,0)
        love.graphics.circle("line", ent.x, ent.y, SIZE)
    end,
    
    initXY = true
}


