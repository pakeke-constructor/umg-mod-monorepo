
--[[
    currnet camera module.
]]

local currentCamera = {}


local constants = require("client.constants")
local newCamera = require("libs.camera") -- HUMP Camera for love2d.

local DEFAULT_ZOOM = constants.DEFAULT_ZOOM

local cam = newCamera(0, 0, nil, nil, DEFAULT_ZOOM, 0)

cam:setDimension(dimensions.getDefaultDimension())


function currentCamera.getCamera()
    --[[
        TODO: we may want to override this function in the
        future, to allow for hotswapping cameras and stuff.
    ]]
    return cam
end


-- TODO:
-- create a `setCamera()` function or something...? idk


return currentCamera
