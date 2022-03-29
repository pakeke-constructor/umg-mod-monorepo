

local DEFAULT = {0,0,0,1}--{0.85,0.85,0.85}

local base_lighting = DEFAULT



local lights = group("x","y","light")


local light_image = graphics.newImage("default_light.png")
local W,H = light_image:getDimensions()

local LEIGH = 20

local canvas = graphics.newCanvas(
    graphics.getWidth() + LEIGH,
    graphics.getHeight() + LEIGH
)



on("resize", function(w,h)
    canvas = graphics.newCanvas(
        graphics.getWidth() + LEIGH,
        graphics.getHeight() + LEIGH
    )
end)



local DEFAULT_RADIUS = 50
local DEFAULT_COLOR = {1,1,1}


local function setupCanvas()
    graphics.push("all")
    graphics.setCanvas(canvas)
    graphics.clear(base_lighting)
    --graphics.setBlendMode("add")

    for _, ent in ipairs(lights) do
        local light = ent.light
        local radius = light.radius or DEFAULT_RADIUS
        local scale = (radius*2) / W
        -- times by 2, because W is twice as large as light image radius
        graphics.setColor(light.color or DEFAULT_COLOR)
        graphics.draw(light_image, ent.x, ent.y, 0, scale, scale, W/2, H/2)
    end

    graphics.setCanvas()
    graphics.pop()
end


local function drawCanvas()
    graphics.push("all")
    graphics.origin()
    graphics.setBlendMode("multiply", "premultiplied")
    graphics.draw(canvas)
    graphics.pop()
end


on("postDraw", function()
    setupCanvas()
    drawCanvas()
end)



local function setBaseLighting(r,g,b)
    if type(r) == "table" then
        r=r[1]
        g=r[2]
        b=r[3]
    end

    assert(type(r) == "number" and type(g) == "number" and type(b) == "number", "Bad usage of graphics.setBaseLighting")
    base_lighting[1] = r
    base_lighting[2] = g
    base_lighting[3] = b
end


return {setBaseLighting = setBaseLighting}
