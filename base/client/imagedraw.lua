

local getQuadOffset = require("client.image_helpers.quad_offsets")

local bobbing = require("client.image_helpers.bobbing")
local spinning = require("client.image_helpers.spinning")
local swaying = require("client.image_helpers.swaying")

local draw = require("client.draw")
local getDrawY = draw.getDrawY


local images = client.assets.images



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

    client.atlas:draw(
        quad, 
        ent.x + ent_ox, getDrawY(ent.y + ent_oy,ent.z), ent.rot, 
        spin_sx * sx * scale, 
        bob_sy * sy * scale, 
        ox + sway_ox,
        bob_oy + oy,
        sway_shearx
    )
end)

