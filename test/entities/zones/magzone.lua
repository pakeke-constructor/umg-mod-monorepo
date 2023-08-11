
local SIZE = 400

return {
    draw = true,
    magentaZone = true,
    drawDepth = -SIZE,
    size = SIZE,
    onDraw = function(ent)
        love.graphics.setLineWidth(5)
        love.graphics.setColor(1,0,1)
        love.graphics.circle("line", ent.x, ent.y, SIZE)
    end,
    
    init = base.initializers.initXY
}


