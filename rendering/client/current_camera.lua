
--[[
    global camera instance.
]]


local constants = require("shared.constants")
local newCamera = require("libs.camera") -- HUMP Camera for love2d.

local DEFAULT_ZOOM = constants.DEFAULT_ZOOM

local camera = newCamera(0, 0, nil, nil, DEFAULT_ZOOM, 0)

return camera
