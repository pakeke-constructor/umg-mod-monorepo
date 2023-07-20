

local zoom_speed = nil

local DEFAULT_ZOOM_SPEED = 22

local MAX_ZOOM = 10
local MIN_ZOOM = 0.1



local zoom = {}


function zoom.setMaxZoom(max_zoom)
    MAX_ZOOM = max_zoom
end

function zoom.setMinZoom(min_zoom)
    MIN_ZOOM = min_zoom
end

function zoom.setZoomSpeed(speed)
    zoom_speed = speed
end

function zoom.setZoom(zoomValue)
    local camera = rendering.getCamera()
    camera.scale = math.max(MIN_ZOOM, math.min(MAX_ZOOM, zoomValue))
end

function zoom.getZoom()
    local camera = rendering.getCamera()
    return camera.scale
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
    camera.scale = math.min(math.max(camera.scale, MIN_ZOOM), MAX_ZOOM)

    self:lockMouseWheel()
end





local last_camx, last_camy = 0, 0




local DEFAULT_PAN_SPEED = 900

local MOUSE_PAN_THRESHOLD = 50 -- X pixels from the screen border to move.


local function moveCam(dt)
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

    camera.x = camera.x + dx
    camera.y = camera.y + dy 
end




local CAMERA_PAN_ACTIVE = false




function listener:keypressed(key, scancode, isrepeat)
    local inputEnum = self:getInputEnum(scancode)
    if inputEnum == input.BUTTON_SHIFT then
        -- camera is panning / in free mode
        CAMERA_PAN_ACTIVE = true
        self:lockKey(scancode)
    end
end



function listener:keyreleased(key, scancode, isrepeat)
    local inputEnum = self:getInputEnum(scancode)
    if inputEnum == input.BUTTON_SHIFT then
        -- Camera is no longer panning
        CAMERA_PAN_ACTIVE = false
    end
end



local function isCameraPanBlocked()
    local blocked = umg.ask("cameraPanBlocked", base.operators.OR)
    return blocked
end



umg.answer("isCameraPlayerFollowBlocked", function()
    return CAMERA_PAN_ACTIVE
end)




function listener:update(dt)
    if isCameraPanBlocked() then
        return
    end
    local camera = rendering.getCamera()

    if CAMERA_PAN_ACTIVE then
        camera.x = last_camx
        camera.y = last_camy
        moveCam(dt)
    end

    last_camx = camera.x
    last_camy = camera.y
end



local MIDDLE_MOUSE_BUTTON = 3

function listener:mousemoved(x,y,dx,dy)
    if CAMERA_PAN_ACTIVE and love.mouse.isDown(MIDDLE_MOUSE_BUTTON) then
        local camera = rendering.getCamera()
        local wx1, wy1 = camera:toWorldCoords(x-dx,y-dy)
        local wx2, wy2 = camera:toWorldCoords(x,y)
        local wdx, wdy = wx2-wx1, wy1-wy2
        last_camx = last_camx - wdx
        last_camy = last_camy + wdy

        self:lockMouseButton(MIDDLE_MOUSE_BUTTON)
    end
end


return zoom
