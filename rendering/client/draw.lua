
local draw = {}


local currentCamera = require("client.current_camera")
local constants = require("client.constants")



local function getCameraPosition()
    -- The camera offset, (i.e. camera is offset 10 pixels to the right)
    local dx, dy = umg.ask("getCameraOffset", reducers.ADD_VECTOR) or 0, 0
    -- previously: getCameraOffsetX, getCameraOffsetY

    -- The global camera position in the world
    local x, y = umg.ask("getCameraPosition", reducers.PRIORITY_VECTOR)
    -- previously: getCameraPositionX, getCameraPositionY

    error("TODO: change all the answers to use the new multi-answer format!")

    return x + dx, y + dy
end






function draw.getCameraPosition()
    --[[
        This provides cacheing, as opposed to polling the reverse
        event buses every single time.
        The "downside" of this is that it has the potential to be one
        frame delayed.
    ]]
    local camera = currentCamera.getCamera()
    return camera.x, camera.y
end



umg.on("drawWorld", function(customCamera)
    --[[
        customCamera is an optional argument.
        should be left nil, most of the time, unless we want something custom.
        
        ALSO: This callback is *highly expensive*. Try to only call once or twice.
    ]]
    local camera = customCamera or currentCamera.getCamera()

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



function draw.drawWorld(customCamera)

end



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
