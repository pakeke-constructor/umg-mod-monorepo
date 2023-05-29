

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

    --[[
        TODO: Bring all these umg.ask calls out into functions,
        so that they can be used by other systems.

        They should also be exposed by the base mod api.

        Also: TODO:
        Do we need to be doing all the funky `if ent.ox` stuff?
        Is the efficiency really worth it?
        (I don't think so. We should change it.)
    ]]
    ox = ox + (ent.ox or 0) + umg.ask("getOffsetX", operators.ADD, ent)
    oy = oy + (ent.oy or 0) + umg.ask("getOffsetY", operators.ADD, ent)

    local scale, sx, sy
    scale = (ent.scale or 1) * umg.ask("getScale", operators.MULT, ent)
    sx = (ent.scaleX or 1) * umg.ask("getScaleX", operators.MULT, ent)
    sy = (ent.scaleY or 1) * umg.ask("getScaleY", operators.MULT, ent)

    local shx, shy
    shx = (ent.shearX or 1) * umg.ask("getShearX", operators.ADD, ent)
    shy = (ent.shearY or 1) * umg.ask("getShearY", operators.ADD, ent)

    drawImage(
        ent.image, 
        ent.x, getDrawY(ent.y, ent.z),
        ent.rot, 
        scale * sx, scale * sy,
        ox, oy,
        shx, shy
    )
end)

