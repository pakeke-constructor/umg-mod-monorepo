
require("light_questions")



local DEFAULT = {0.55,0.55,0.7,1} --{0.85,0.85,0.85}



--[[
    important note:
    This image is stored OUTSIDE of assets/images,
    which means that it won't be loaded by the texture atlas.
]]
local DEFAULT_LIGHT_IMAGE = "lights/default_light.png"


local defaultLighting = DEFAULT


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



local DEFAULT_SIZE = 50
local DEFAULT_COLOR = {1,1,1}




local function setupCanvas(camera)
    love.graphics.push("all")
    love.graphics.setCanvas(canvas)

    -- reset lights:
    local dimension = camera:getDimension()
    local overseerEnt = dimensions.getOverseer(dimension)
    local col = overseerEnt.baseLighting or defaultLighting
    love.graphics.clear(col)

    local globalSizeMod = umg.ask("light:getGlobalLightSizeMultiplier") or 1

    -- display all lights:
    for _, ent in ipairs(lightGroup) do
        -- TODO: Check if entity is on the screen
        -- (its hard because of canvases, lg.getWidth() is not available)
        local dim = dimensions.getDimension(ent)
        if dim == dimension then
            local l = ent.light
            local size = l.size or DEFAULT_SIZE
            local sizeMod = umg.ask("light:getLightSizeMultiplier", ent) or 1
            local scale = (size / W) * sizeMod * globalSizeMod
            love.graphics.setColor(l.color or DEFAULT_COLOR)
            love.graphics.draw(light_image, ent.x, ent.y, 0, scale, scale, W/2, H/2)
        end
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


umg.on("rendering:postDrawWorld", function(camera)
    setupCanvas(camera)
    local mode, alphamode = love.graphics.getBlendMode( )
    drawCanvas()
    love.graphics.setBlendMode(mode, alphamode)
end)



local rgbTc = typecheck.assert("number", "number", "number")


local function getColor(r,g,b)
    if type(r) == "table" then
        r,g,b = r[1],r[2],r[3]
    end
    rgbTc(r,g,b)
    return objects.Color({r,g,b})
end


function light.setDefaultLighting(r,g,b)
    local color = getColor(r,g,b)
    defaultLighting = color
end


local setLightingTc = typecheck.assert("dimension")


function light.setLighting(dimension, r,g,b)
    setLightingTc(dimension, r,g,b)
    local color = getColor(r,g,b)
    local overseerEnt = dimension.getOverseer(dimension)
    overseerEnt.lighting = color
end



umg.expose("light", light)


