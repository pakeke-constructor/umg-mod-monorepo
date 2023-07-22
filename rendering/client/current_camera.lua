
--[[
    currnet camera module.
]]

local currentCamera = {}


local constants = require("client.constants")
local newCamera = require("libs.camera") -- HUMP Camera for love2d.

local DEFAULT_ZOOM = constants.DEFAULT_ZOOM

local default_cam = newCamera(0, 0, nil, nil, DEFAULT_ZOOM, 0)


function currentCamera.getCamera()
    --[[
        TODO: we may want to override this function in the
        future, to allow for hotswapping cameras and stuff.
    ]]
    return default_cam
end


function currentCamera.getCameraPosition()
    local dx = umg.ask("getCameraOffsetX", reducers.ADD)
    local dy = umg.ask("getCameraOffsetY", reducers.ADD)
    -- The camera offset, (i.e. camera is offset 10 pixels to the right)

    local x = umg.ask("getCameraPositionX", reducers.LAST)
    local y = umg.ask("getCameraPositionY", reducers.LAST)
    -- The global camera position in the world

    return x + dx, y + dy
end





-- TODO:
-- create a `setCamera()` function or something...? idk



return currentCamera
