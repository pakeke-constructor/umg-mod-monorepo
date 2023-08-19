

local LEIGH = 20

local canvas = love.graphics.newCanvas(
    love.graphics.getWidth() + LEIGH,
    love.graphics.getHeight() + LEIGH
)



umg.on("@resize", function(w,h)
    canvas = love.graphics.newCanvas(
        love.graphics.getWidth() + LEIGH,
        love.graphics.getHeight() + LEIGH
    )
end)



local BORDER_COLOR = {0.3,0.3,0.3}
local DIAGONAL_COLOR = {0.6,0.6,0.6}
local BORDER_LINE_COLOR = {0,0,0}

local BORDER_LINE_THICKNESS = 8

local DIAGONAL_SIZE = 80

local function drawDiagonalBars()
    love.graphics.rotate(math.pi/4)
    local cam = rendering.getCamera()
    local cx, cy = cam.x, cam.y
    local dy = (cy - cx) / math.sqrt(2) 
    for i=-50, 50 do
        love.graphics.rectangle(
            "fill", -0xffffff, dy + i * DIAGONAL_SIZE,
            0xfffffffff, DIAGONAL_SIZE / 2
        )
    end
end





local function setupCanvas(border)
    love.graphics.push("all")
    love.graphics.setCanvas(canvas)
    love.graphics.clear(BORDER_COLOR)

    -- draw diagonal bars:
    love.graphics.push()
    love.graphics.setColor(DIAGONAL_COLOR)
    drawDiagonalBars()
    love.graphics.pop()
    
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", border.x, border.y, border.width, border.height)

    love.graphics.setCanvas()
    love.graphics.pop()
end


local function drawCanvas()
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.push("all")
    love.graphics.origin()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas()
    love.graphics.draw(canvas)
    love.graphics.pop()
end





umg.on("rendering:postDrawWorld", function(camera)
    local dimension = camera:getDimension()
    local overseerEnt = dimensions.getOverseer(dimension)
    local border = overseerEnt.border

    if border then
        setupCanvas(border)

        local mode, alphamode = love.graphics.getBlendMode()
        drawCanvas()
        love.graphics.setBlendMode(mode, alphamode)

        love.graphics.setLineWidth(BORDER_LINE_THICKNESS)
        love.graphics.setColor(BORDER_LINE_COLOR)
        love.graphics.rectangle("line", border.x, border.y, border.width, border.height)
    end
end)






