


local borderGroup = umg.group("border")

local controllableGroup = umg.group("controllable", "controller", "x", "y")





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



local function setupCanvas()
    love.graphics.push("all")
    love.graphics.setCanvas(canvas)
    love.graphics.clear(BORDER_COLOR)

    love.graphics.push()
    love.graphics.setColor(DIAGONAL_COLOR)
    drawDiagonalBars()
    love.graphics.pop()
    
    for _, ent in ipairs(borderGroup) do
        local border = ent.border
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", border.x, border.y, border.width, border.height)
    end

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


umg.on("postDrawWorld", function()
    if #borderGroup > 0 then
        setupCanvas()

        local mode, alphamode = love.graphics.getBlendMode( )
        drawCanvas()
        love.graphics.setBlendMode(mode, alphamode)
    

        for _, ent in ipairs(borderGroup) do
            local border = ent.border
            love.graphics.setLineWidth(BORDER_LINE_THICKNESS)
            love.graphics.setColor(BORDER_LINE_COLOR)
            love.graphics.rectangle("line", border.x, border.y, border.width, border.height)
        end
    end
end)


local EPSILON = 0.01

umg.on("state:gameUpdate", function(dt)
    --[[
        we restrict controllable entities to the border,
        just so it's more responsive on client-side.
    ]]
    for _, ent in ipairs(controllableGroup) do
        local entIsWithin = false
        local closestBorder = nil
        local closestBorderDistance = math.huge
    
        if sync.isClientControlling(ent) then
            for _, borderEnt in ipairs(borderGroup) do
                local border = borderEnt.border
                local distance = border:distanceFromBorderEdge(ent.x, ent.y)
                if distance < EPSILON then
                    -- we're inside the border, this entity is fine.
                    entIsWithin = true
                    break
                else
                    if distance < closestBorderDistance then
                        closestBorderDistance = distance
                        closestBorder = border
                    end
                end
            end
        end

        if (not entIsWithin) and closestBorder then
            ent.x, ent.y = closestBorder:clampToWithinBorder(ent.x, ent.y)
        end
    end
end)

