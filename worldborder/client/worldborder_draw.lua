

local worldborder = require("shared.worldborder")


local canvas = love.graphics.newCanvas()



local function drawCanvas()
    love.graphics.push("all")
    love.graphics.origin()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas()
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.draw(canvas)
    love.graphics.pop()
end




umg.on("drawEffects", function()
    love.graphics.push("all")
    
    -- reset camera
    love.graphics.reset()
    love.graphics.origin()

    love.graphics.setCanvas(canv)
    


    love.graphics.setCanvas()
    love.graphics.pop()
end)


