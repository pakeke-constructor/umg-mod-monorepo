

local DEFAULT = {0.55,0.55,0.7,1} --{0.85,0.85,0.85}

local DEFAULT_LIGHT_IMAGE = "default_light.png"

local base_lighting = DEFAULT


local light = {}

local lightGroup = umg.group("x","y","light")


local light_image, W, H


function light.setLightImage(imgName)
    light_image = love.graphics.newImage(imgName)
    W, H = light_image:getDimensions()
end


light.setLightImage(DEFAULT_LIGHT_IMAGE)



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



local DEFAULT_RADIUS = 50
local DEFAULT_COLOR = {1,1,1}


local function setupCanvas()
    love.graphics.push("all")
    love.graphics.setCanvas(canvas)
    love.graphics.clear(base_lighting)
    --love.graphics.setBlendMode("add")

    for _, ent in ipairs(lightGroup) do
        -- TODO: Check if entity is on the screen
        local l = ent.light
        local radius = l.radius or DEFAULT_RADIUS
        local scale = (radius*2) / W
        -- times by 2, because W is twice as large as light image radius
        love.graphics.setColor(l.color or DEFAULT_COLOR)
        love.graphics.draw(light_image, ent.x, ent.y, 0, scale, scale, W/2, H/2)
    end

    love.graphics.setCanvas()
    love.graphics.pop()
end


local function drawCanvas()
    love.graphics.push("all")
    love.graphics.origin()

    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas()
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.draw(canvas)
    love.graphics.pop()
end


umg.on("postDrawWorld", function()
    setupCanvas()
    local mode, alphamode = love.graphics.getBlendMode( )
    drawCanvas()
    love.graphics.setBlendMode(mode, alphamode)
end)



function light.setBaseLighting(r,g,b)
    if type(r) == "table" then
        g=r[2]
        b=r[3]
        r=r[1]
    end

    assert(type(r) == "number" and type(g) == "number" and type(b) == "number", "Bad usage of love.graphics.setBaseLighting")
    base_lighting[1] = r
    base_lighting[2] = g
    base_lighting[3] = b
end



umg.expose("light", light)


