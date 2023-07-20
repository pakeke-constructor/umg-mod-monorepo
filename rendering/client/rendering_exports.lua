

local rendering = {}


local animate = require("client.animate")

local draw = require("client.draw")
local drawEntities = require("client.draw_entities")


local camera_instance = require("client.current_camera")



function rendering.getCamera()
    --[[
        TODO: we may want to override this function in the
        future, to allow for hotswapping cameras and stuff.
    ]]
    return camera_instance
end


rendering.getUIScale = draw.getUIScale
rendering.setUIScale = draw.setUIScale



-- TODO: Is this function needed???
rendering.getUIMousePosition = draw.getUIMousePosition




rendering.isOnScreen = drawEntities.isOnScreen
rendering.entIsOnScreen = drawEntities.entIsOnScreen

rendering.drawEntity = drawEntities.drawEntity

rendering.getDrawY = drawEntities.getDrawY;
rendering.getDrawDepth = drawEntities.getDrawDepth;



--[[
    TODO: 
    Rename this. `drawStats` is terrible naming!!!
    Perhaps we could just export the functions inside of drawStats
    to the `rendering` table directly?
    Or maybe change the name to `info`?
    `rendering.info.getScaleX`..?
    ^^^ I like this a lot more than "drawStats" tbh.
]]
rendering.drawStats = require("client.helpers.draw_stats")


rendering.getImageOffsets = require("client.helpers.image_offsets");

rendering.drawImage = require("client.helpers.draw_image");


function rendering.toScreenCoords(world_x, world_y)
    local cam = rendering.getCamera()
    return cam:toCameraCoords(world_x, world_y)
end


function rendering.toWorldCoords(x,y)
    local cam = rendering.getCamera()
    return cam:toWorldCoords(x,y)
end


function rendering.getMousePositionInWorld()
    local cam = rendering.getCamera()
    return cam:getMousePosition()
end


rendering.animate = animate.animate;
rendering.animateEntity = animate.animateEntity;


return rendering

