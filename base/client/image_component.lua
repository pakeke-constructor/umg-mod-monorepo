

local getQuadOffset = require("client.image_helpers.quad_offsets")

local bobbing = require("client.image_helpers.bobbing")
local spinning = require("client.image_helpers.spinning")
local swaying = require("client.image_helpers.swaying")

local drawEntities = require("client.draw_entities")
local drawImage = require("client.image_helpers.draw_image")

local operators = require("shared.operators")


local getDrawY = drawEntities.getDrawY


local images = client.assets.images



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

    local ox, oy = getQuadOffset(quad)

    local bob_oy, bob_sy = bobbing(ent, oy)
    local sway_ox, sway_shearx = swaying(ent, ox)
    local spin_sx = spinning(ent)

    local scale = ent.scale or 1
    local sx = ent.scaleX or 1
    local sy = ent.scaleY or 1

    local ent_ox, ent_oy = ent.ox or 0, ent.oy or 0

    drawImage(
        ent.image, 
        ent.x + ent_ox, getDrawY(ent.y + ent_oy,ent.z),
        ent.rot, 
        spin_sx * sx * scale, 
        bob_sy * sy * scale, 
        sway_ox,
        bob_oy,
        sway_shearx
    )
end)



local entityStats = require("client.image_helpers.entity_stats")

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

    local ox, oy = getQuadOffset(quad)

    ox = ox + getOffsetX(ent)
    oy = oy + getOffsetY(ent)

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

