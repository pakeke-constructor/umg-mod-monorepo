
local draw = {}


local currentCamera = require("client.current_camera")
local constants = require("client.constants")



local function getCameraPosition()
    -- The camera offset, (i.e. camera is offset 10 pixels to the right)
    local dx = umg.ask("getCameraOffsetX", reducers.ADD) or 0
    local dy = umg.ask("getCameraOffsetY", reducers.ADD) or 0

    -- The global camera position in the world
    -- (We take the last non-nil value for this)
    local x = umg.ask("getCameraPositionX", reducers.LAST) or 0
    local y = umg.ask("getCameraPositionY", reducers.LAST) or 0

    return x + dx, y + dy
end

draw.getCameraPosition = getCameraPosition





umg.on("drawWorld", function()
    local camera = currentCamera.getCamera()

    local x, y = getCameraPosition()
    camera:follow(x, y)
    camera:update(love.timer.getDelta())

    camera:attach()

    umg.call("preDrawWorld")

    umg.call("drawGround")
    umg.call("drawEntities")
    umg.call("drawEffects")

    camera:draw()

    umg.call("postDrawWorld")

    camera:detach()
end)






-- Oli's personal screen width and height (used in fudgeUIScale)
-- todo: this is dumb
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


function draw.setUIScale(scale)
    assert(type(scale) == "number", "love.graphics.setUIScale(scale) requires a number")
    scaleUI = fudgeUIScale(scale)
end


function draw.getUIScale()
    return scaleUI
end


function draw.getUIMousePosition()
    -- gets the mouse position within the UI context
    local mouse_x, mouse_y = love.mouse.getPosition()
    local ui_scale = draw.getUIScale()
    local mx, my = mouse_x / ui_scale, mouse_y / ui_scale
    return mx, my
end





umg.on("drawUI", function()
    love.graphics.scale(scaleUI)
    umg.call("preDrawUI")
    umg.call("mainDrawUI")
    umg.call("postDrawUI")
end)



return draw
