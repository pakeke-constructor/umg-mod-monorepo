
local getQuadOffsets = require("client.image_helpers.quad_offsets")

local drawEntities = require("client.draw_entities")
local drawImage = require("client.image_helpers.draw_image")


local getDrawY = drawEntities.getDrawY


local images = client.assets.images


local entityStats = require("client.image_helpers.draw_stats")

local getOffsetX = entityStats.getOffsetX
local getOffsetY = entityStats.getOffsetY

local getRotation = entityStats.getRotation

local getScale = entityStats.getScale
local getScaleX = entityStats.getScaleX
local getScaleY = entityStats.getScaleY

local getShearX = entityStats.getShearX
local getShearY = entityStats.getShearY




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

