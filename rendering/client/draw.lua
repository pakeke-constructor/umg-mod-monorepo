
local draw = {}


local currentCamera = require("client.current_camera")
local constants = require("client.constants")



local function getCameraPosition()
    -- The camera offset, (i.e. camera is offset 10 pixels to the right)
    local dx, dy = umg.ask("rendering:getCameraOffset") 
    if not dx then
        dx, dy = 0, 0
    end

    -- The global camera position in the world
    local x, y = umg.ask("rendering:getCameraPosition") 
    if not x then
        x, y = 0, 0
    end

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


function draw.drawWorld(customCamera)
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

    umg.call("rendering:drawGround", camera)

    -- IN-FUTURE: Draw predraw pixelated effects canvas here.
    -- used for stuff like ground-dust, background-fx, etc

    umg.call("rendering:drawEntities", camera)

    -- IN-FUTURE: Draw pixelated effects canvas here
    -- Used for stuff like spells, powerups, etc

    umg.call("rendering:drawEffects", camera)

    camera:draw()
    camera:detach()
end



umg.on("state:drawWorld", function()
    draw.drawWorld()
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



local MIN_SCALE = 0.001 -- UI scale cant be lower than this.
-- The reason we need a min value here is to avoid division by 0

function draw.setUIScale(scale)
    assert(type(scale) == "number", "love.graphics.setUIScale(scale) requires a number")
    scaleUI = math.max(fudgeUIScale(scale), MIN_SCALE)
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





umg.on("state:drawUI", function()
    love.graphics.scale(scaleUI)
    umg.call("rendering:drawUI")
end)



return draw
