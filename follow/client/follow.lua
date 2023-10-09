

local follow = {}



local zoom_speed = nil

local DEFAULT_ZOOM_SPEED = 22

local MAX_ZOOM = 10
local MIN_ZOOM = 0.1




function follow.setMaxZoom(max_zoom)
    MAX_ZOOM = max_zoom
end

function follow.setMinZoom(min_zoom)
    MIN_ZOOM = min_zoom
end


local MIN_ZOOM_SPEED = 0.0000001
local MAX_ZOOM_SPEED = 100000000
function follow.setZoomSpeed(speed)
    zoom_speed = math.clamp(speed, MIN_ZOOM_SPEED, MAX_ZOOM_SPEED)
end




local listener = input.Listener({priority = 0})


function listener:wheelmoved(dx,dy)
    local camera = rendering.getCamera()
    local speed = zoom_speed or DEFAULT_ZOOM_SPEED
    if dy > 0 then
        camera.scale = camera.scale * (1+(1/speed))
    else
        camera.scale = camera.scale * (1-(1/speed))
    end

    -- now clamp:
    camera.scale = math.clamp(camera.scale, MIN_ZOOM, MAX_ZOOM)

    self:lockMouseWheel()
end





local last_camx, last_camy = 0, 0




local DEFAULT_PAN_SPEED = 900

local MOUSE_PAN_THRESHOLD = 50 -- X pixels from the screen border to move.


local function followMouseNearEdge(dt)
    local dx,dy = 0,0
    local x, y = love.mouse.getPosition()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local camera = rendering.getCamera()
    local speed = (DEFAULT_PAN_SPEED * dt) / camera.scale

    if x < MOUSE_PAN_THRESHOLD then
        dx = -speed
    elseif x > (w - MOUSE_PAN_THRESHOLD) then
        dx = speed
    end

    if y < MOUSE_PAN_THRESHOLD then
        dy = -speed
    elseif y > (h - MOUSE_PAN_THRESHOLD) then
        dy = speed
    end

    last_camx = last_camx + dx
    last_camy = last_camy + dy
end




local CAMERA_PAN_ACTIVE = false




function listener:keypressed(key, scancode, isrepeat)
    local inputEnum = self:getKeyboardInputEnum(scancode)
    if inputEnum == input.BUTTON_SHIFT then
        -- camera is panning / in free mode
        CAMERA_PAN_ACTIVE = true
        self:lockKey(scancode)
    end
end



function listener:keyreleased(key, scancode, isrepeat)
    local inputEnum = self:getKeyboardInputEnum(scancode)
    if inputEnum == input.BUTTON_SHIFT then
        -- Camera is no longer panning
        CAMERA_PAN_ACTIVE = false
    end
end


function listener:update(dt)
    if CAMERA_PAN_ACTIVE then
        -- move the camera if the mouse is near edge of screen
        followMouseNearEdge(dt)
    else
        local camera = rendering.getCamera()
        last_camx = camera.x
        last_camy = camera.y
    end
end



local MIDDLE_MOUSE_BUTTON = 3

function listener:mousemoved(x,y,dx,dy)
    if CAMERA_PAN_ACTIVE and love.mouse.isDown(MIDDLE_MOUSE_BUTTON) then
        -- use middle mouse button to pan camera
        local wx1, wy1 = rendering.toWorldCoords(x-dx,y-dy)
        local wx2, wy2 = rendering.toWorldCoords(x,y)
        local wdx, wdy = wx2-wx1, wy1-wy2
        last_camx = last_camx - wdx
        last_camy = last_camy + wdy

        self:lockMouseButton(MIDDLE_MOUSE_BUTTON)
    end
end



local CAMERA_PAN_PRIORITY = 50

umg.answer("rendering:getCameraPosition", function()
    if CAMERA_PAN_ACTIVE then
        return last_camx, last_camy, CAMERA_PAN_PRIORITY
    end
    return nil -- allow for another system to take control
end)





umg.expose("follow", follow)

