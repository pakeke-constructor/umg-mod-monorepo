

local vignette = {}


local vignetteColor = {1,1,1}
local vignetteStrength = 0.4



local setColorTC = typecheck.assert("table")

function vignette.setColor(color)
    setColorTC(color)
end


local setStrengthTC = typecheck.assert("number")

function vignette.setStrength(strength)
    setStrengthTC(strength)
    vignetteStrength = math.clamp(strength, 0, 1)
end

--[[

TODO:
Allow for flashing different colors,
i.e. flash red when the player takes damage or something.

This should be done in an easy way, EG:

vignette.flash({
    duration = 5,
    color = {1,0,0}
})

]]








local LEIGH = 4

local canvas = love.graphics.newCanvas(
    love.graphics.getWidth() + LEIGH,
    love.graphics.getHeight() + LEIGH
)



umg.on("@resize", function()
    canvas = love.graphics.newCanvas(
        love.graphics.getWidth() + LEIGH,
        love.graphics.getHeight() + LEIGH
    )
end)



--[[
    important note:
    This image is stored OUTSIDE of assets/images,
    which means that it won't be loaded by the texture atlas.
]]
local DEFAULT_VIGNETTE_IMAGE = "vignette.png"
local vignetteImage = love.graphics.newImage(DEFAULT_VIGNETTE_IMAGE)



local function setupCanvas()
    love.graphics.setCanvas(canvas)
    love.graphics.clear(1,1,1,1)

    local r,g,b,a = vignetteColor[1], vignetteColor[2], vignetteColor[3], vignetteStrength
    love.graphics.setColor(r,g,b,a)
    local canvW, canvH = canvas:getDimensions()
    local imgW, imgH = vignetteImage:getDimensions()
    love.graphics.draw(vignetteImage, -LEIGH/2, -LEIGH/2, 0, canvW / imgW, canvH / imgH)

    love.graphics.setCanvas()
end


local function drawCanvas()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas()
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.draw(canvas)
end


umg.on("rendering:postDrawWorld", function()
    local mode, alphamode = love.graphics.getBlendMode()
    love.graphics.push("all")
    love.graphics.origin()

    setupCanvas()
    drawCanvas()
    
    love.graphics.pop()
    love.graphics.setBlendMode(mode, alphamode)
end)




umg.expose("vignette", vignette)
