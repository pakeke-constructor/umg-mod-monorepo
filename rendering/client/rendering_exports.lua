

local rendering = {}


local animate = require("client.animate")

local draw = require("client.draw")
local drawEntities = require("client.draw_entities")


local currentCamera = require("client.current_camera")
local cameraLib = require("libs.camera")


-- access to custom cameras
rendering.Camera = cameraLib

rendering.getCamera = currentCamera.getCamera


rendering.getUIScale = draw.getUIScale
rendering.setUIScale = draw.setUIScale




rendering.isOnScreen = drawEntities.isOnScreen
rendering.entIsOnScreen = drawEntities.entIsOnScreen

rendering.drawEntity = drawEntities.drawEntity

rendering.getDrawY = drawEntities.getDrawY;
rendering.getDrawDepth = drawEntities.getDrawDepth;



local entityProperties = require("client.helper.entity_properties")
rendering.entityProperties = entityProperties


local imageSizes = require("client.helper.image_offsets");
rendering.getImageOffsets = imageSizes.getImageOffsets
rendering.getImageSize = imageSizes.getImageSize


rendering.drawImage = require("client.helper.draw_image");






function rendering.toScreenCoords(world_x, world_y)
    local cam = rendering.getCamera()
    return cam:toCameraCoords(world_x, world_y)
end


function rendering.toWorldCoords(x,y)
    local cam = rendering.getCamera()
    return cam:toWorldCoords(x,y)
end


function rendering.getWorldMousePosition()
    local cam = rendering.getCamera()
    return cam:getMousePosition()
end


-- TODO: Is this function needed???
rendering.getUIMousePosition = draw.getUIMousePosition



rendering.animate = animate.animate;
rendering.animateEntity = animate.animateEntity;


rendering.isHovered = require("client.helper.is_hovered")
rendering.getEntityDisplaySize = require("client.helper.entity_display_size")


umg.expose("rendering", rendering)

return rendering

