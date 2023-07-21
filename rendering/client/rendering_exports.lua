

local rendering = {}


local animate = require("client.animate")

local draw = require("client.draw")
local drawEntities = require("client.draw_entities")


local currentCamera = require("client.current_camera")



rendering.getCamera = currentCamera.getCamera


rendering.getUIScale = draw.getUIScale
rendering.setUIScale = draw.setUIScale




rendering.isOnScreen = drawEntities.isOnScreen
rendering.entIsOnScreen = drawEntities.entIsOnScreen

rendering.drawEntity = drawEntities.drawEntity

rendering.getDrawY = drawEntities.getDrawY;
rendering.getDrawDepth = drawEntities.getDrawDepth;



local entityProperties = require("client.helpers.entity_properties")
rendering.entityProperties = entityProperties


local imageSizes = require("client.helpers.image_offsets");
rendering.getImageOffsets = imageSizes.getImageOffsets
rendering.getImageSize = imageSizes.getImageSize


rendering.drawImage = require("client.helpers.draw_image");




function rendering.getEntityDisplaySize(ent)
    --[[
        returns (roughly) the (width, height) of an entity
    ]]
    local scale = entityProperties.getScale(ent)

    local sx = entityProperties.getScaleX(ent) * scale
    local sy = entityProperties.getScaleY(ent) * scale

    assert(ent.image, "Entity had no image component!")
    local size_x, size_y = rendering.getImageSize(ent)

    return sx * size_x, sy * size_y
end




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


umg.expose("rendering", rendering)

return rendering

