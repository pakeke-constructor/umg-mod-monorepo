

local misc = require("client.misc")
local drawImage = require("client.helper.draw_image")


local getDrawY = misc.getDrawY


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

local getImage = entityProperties.getImage



local imageGroup = umg.group("image")

imageGroup:onAdded(function(ent)
    if not ent.draw then
        ent.draw = true
    end
end)




umg.on("rendering:drawEntity", function(ent)
    local img = getImage(ent)
    if not img then
        return -- no image, don't draw.
    end

    local quad = images[img]
    if not quad then
        if type(img) ~= "string" then
            error(("Incorrect type for entity image. Expected string, got: %s"):format(type(ent.image)))
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
        img, 
        ent.x, getDrawY(ent.y, ent.z),
        rot, 
        scale * sx, scale * sy,
        ox, oy,
        shx, shy
    )
end)

