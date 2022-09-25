

local DEFAULT = {0.55,0.55,0.7,1} --{0.85,0.85,0.85}

local DEFAULT_LIGHT_IMAGE = "default_light.png"

local base_lighting = DEFAULT


local light = {}

local lights = group("x","y","light")


local light_image, W, H


function light.setLightImage(imgName)
    light_image = graphics.newImage(imgName)
    W, H = light_image:getDimensions()
end


light.setLightImage(DEFAULT_LIGHT_IMAGE)



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
        -- TODO: Check if entity is on the screen
        local l = ent.light
        local radius = l.radius or DEFAULT_RADIUS
        local scale = (radius*2) / W
        -- times by 2, because W is twice as large as light image radius
        graphics.setColor(l.color or DEFAULT_COLOR)
        graphics.draw(light_image, ent.x, ent.y, 0, scale, scale, W/2, H/2)
    end

    graphics.setCanvas()
    graphics.pop()
end


local function drawCanvas()
    graphics.push("all")
    graphics.origin()
    graphics.setColor(1,1,1,1)
    graphics.setCanvas()
    graphics.setBlendMode("multiply", "premultiplied")
    graphics.draw(canvas)
    graphics.pop()
end


on("postDraw", function()
    setupCanvas()
    drawCanvas()
end)



function light.setBaseLighting(r,g,b)
    if type(r) == "table" then
        g=r[2]
        b=r[3]
        r=r[1]
    end

    assert(type(r) == "number" and type(g) == "number" and type(b) == "number", "Bad usage of graphics.setBaseLighting")
    base_lighting[1] = r
    base_lighting[2] = g
    base_lighting[3] = b
end



export("light", light)


