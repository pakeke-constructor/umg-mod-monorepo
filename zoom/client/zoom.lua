

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
    base.camera.scale = math.max(MIN_ZOOM, math.min(MAX_ZOOM, zoomValue))
end

function zoom.getZoom()
    return base.camera.scale
end




local listener = base.input.Listener({priority = 0})


function listener:wheelmoved(dx,dy)
    local speed = zoom_speed or DEFAULT_ZOOM_SPEED
    if dy > 0 then
        base.camera.scale = base.camera.scale * (1+(1/speed))
    else
        base.camera.scale = base.camera.scale * (1-(1/speed))
    end

    -- now clamp:
    base.camera.scale = math.min(math.max(base.camera.scale, MIN_ZOOM), MAX_ZOOM)

    self:lockMouseWheel()
end





local last_camx, last_camy = base.camera.x or 0, base.camera.y or 0




local DEFAULT_PAN_SPEED = 900

local MOUSE_PAN_THRESHOLD = 50 -- X pixels from the screen border to move.


local function moveCam(dt)
    local dx,dy = 0,0
    local x, y = love.mouse.getPosition()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local speed = (DEFAULT_PAN_SPEED * dt) / base.camera.scale

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

    base.camera.x = base.camera.x + dx
    base.camera.y = base.camera.y + dy 
end


local IS_PAN_MODE = false



local controllableGroup = umg.group("controllable", "controller", "x", "y")



function listener:keypressed(key, scancode, isrepeat)
    local inputEnum = self:getInputEnum(scancode)
    if inputEnum == base.input.BUTTON_SHIFT then
        -- unlock camera
        IS_PAN_MODE = true
        for _, ent in ipairs(controllableGroup)do
            --[[
                TODO: FUTURE OLI HERE.
                WTF IS ALL THIS???? REMOVE ALL OF THIS, WTF
            ]]
            -- we set follow to false for ALL ents, regardless of whether we
            -- are controlling them or not.
            -- This is so if control is changed dynamically, nothing will break.
            -- (This is also a desync between client-server, but it doesn't matter,
            --  because .follow is only used on clientside.)
            ent.follow = false
        end

        self:lockKey(scancode)
    end
end



function listener:keypressed(key, scancode, isrepeat)
    local inputEnum = self:getInputEnum(scancode)
    if inputEnum == base.input.BUTTON_SHIFT then
        -- lock camera.
        IS_PAN_MODE = false
        for _, ent in ipairs(controllableGroup) do
            --[[
                TODO: FUTURE OLI HERE.
                WTF IS ALL THIS???? REMOVE ALL OF THIS, WTF
            ]]
            ent.follow = true
        end
    end
end


function listener:update(dt)
    if IS_PAN_MODE then
        base.camera.x = last_camx
        base.camera.y = last_camy
        moveCam(dt)
    end

    last_camx = base.camera.x
    last_camy = base.camera.y
end



local MIDDLE_MOUSE_BUTTON = 3

function listener:mousemoved(x,y,dx,dy)
    if love.mouse.isDown(MIDDLE_MOUSE_BUTTON) then
        local c = base.camera
        local wx1, wy1 = c:toWorldCoords(x-dx,y-dy)
        local wx2, wy2 = c:toWorldCoords(x,y)
        local wdx, wdy = wx2-wx1, wy1-wy2
        last_camx = last_camx - wdx
        last_camy = last_camy + wdy

        self:lockMouseButton(MIDDLE_MOUSE_BUTTON)
    end
end


return zoom
