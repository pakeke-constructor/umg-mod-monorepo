

local drawEntities = require("client.draw_entities")
local drawImage = require("client.helper.draw_image")


local getDrawY = drawEntities.getDrawY


local images = client.assets.images


local entityProperties = require("client.helper.entity_properties")

local getOffsetX = entityProperties.getOffsetX
local getOffsetY = entityProperties.getOffsetY

local getRotation = entityProperties.getRotation

local getScale = entityProperties.getScale
local getScaleX = entityProperties.getScaleX
local getScaleY = entityProperties.getScaleY

local getShearX = entityProperties.getShearX
local getShearY = entityProperties.getShearY




--[[
    currently, any entity that is drawn will have an image
    (may not stay this way!)
]]
umg.on("drawEntity", function(ent)
    local quad = images[ent.image]
    if not quad then
        if type(ent.image) ~= "string" then
            error(("Incorrect type for ent.image. Expected string, got: %s"):format(type(ent.image)))
        end
        error(("Unknown ent.image value: %s\nMake sure you put all images in the assets folder and name them!"):format(tostring(ent.image)))
    end


    local ox = getOffsetX(ent)
    local oy = getOffsetY(ent)

    local rot = getRotation(ent)

    local scale = getScale(ent)
    local sx = getScaleX(ent)
    local sy = getScaleY(ent)

    local shx, shy
    shx = getShearX(ent)
    shy = getShearY(ent)

    drawImage(
        ent.image, 
        ent.x, getDrawY(ent.y, ent.z),
        rot, 
        scale * sx, scale * sy,
        ox, oy,
        shx, shy
    )
end)

