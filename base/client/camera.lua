
local cameraLib = require("_libs.camera") -- HUMP Camera for love2d.

local DEFAULT_ZOOM = constants.DEFAULT_ZOOM

local camera = cameraLib(0, 0, nil, nil, DEFAULT_ZOOM, 0)


return camera
