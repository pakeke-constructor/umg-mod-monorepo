
local camera = require("client.camera")
local constants = require("shared.constants")


umg.on("drawWorld", function()    
    camera:draw()
    camera:attach()

    umg.call("preDrawWorld")

    umg.call("drawGround")
    umg.call("drawEntities")
    umg.call("drawEffects")

    umg.call("postDrawWorld")

    camera:detach()
end)






-- Oli's personal screen width and height (used in fudgeUIScale)
local OLI_WIDTH, OLI_HEIGHT = 1536, 793
local OLI_DISPLAY_SIZE = math.sqrt(OLI_WIDTH^2 + OLI_HEIGHT^2)


local scaleUI = constants.DEFAULT_UI_SCALE


local function fudgeUIScale(scale)
    --[[
        since different computers have different screen sizes,
        we must scale the UI scale with the screensize.
        bigger sized screens should get larger UI scales to compensate.
    ]]
    local w,h = love.graphics.getDimensions()
    local screensize = math.sqrt(w^2 + h^2)
    return math.round((scale / OLI_DISPLAY_SIZE) * screensize)
end


local function setUIScale(scale)
    assert(type(scale) == "number", "love.graphics.setUIScale(scale) requires a number")
    scaleUI = fudgeUIScale(scale)
end

local function getUIScale()
    return scaleUI
end






umg.on("drawUI", function()
    love.graphics.scale(scaleUI)
    umg.call("preDrawUI")
    umg.call("mainDrawUI")
    umg.call("postDrawUI")
end)




return {
    setUIScale = setUIScale,
    getUIScale = getUIScale
}
