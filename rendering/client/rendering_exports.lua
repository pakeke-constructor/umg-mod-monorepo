

local rendering = {}


local animate = require("client.animate")
local camera = require("client.current_camera")

local draw = require("client.draw")
local drawEntities = require("client.draw_entities")


rendering.camera = camera;


rendering.isHovered = require("client.mouse_hover")

rendering.getUIScale = draw.getUIScale
rendering.setUIScale = draw.setUIScale
rendering.getUIMousePosition = draw.getUIMousePosition

rendering.isOnScreen = drawEntities.isOnScreen
rendering.entIsOnScreen = drawEntities.entIsOnScreen

rendering.drawEntity = drawEntities.drawEntity

rendering.getDrawY = drawEntities.getDrawY;
rendering.getDrawDepth = drawEntities.getDrawDepth;

rendering.drawStats = require("client.helpers.draw_stats")


rendering.getImageOffsets = require("client.helpers.image_offsets");

rendering.drawImage = require("client.helpers.draw_image");


function rendering.toScreenCoords(world_x, world_y)
    return camera:toCameraCoords(world_x, world_y)
end


function rendering.toWorldCoords(x,y)
    return camera:toWorldCoords(x,y)
end


function rendering.getMousePositionInWorld()
    return camera:getMousePosition()
end


rendering.animate = animate.animate;
rendering.animateEntity = animate.animateEntity;


return rendering

