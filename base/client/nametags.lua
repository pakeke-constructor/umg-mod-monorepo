

local nametagGroup = group("x", "y", "nametag", "image")


local DEFAULT = "UNNAMED"

local quad_offsets = require("client.image_helpers.quad_offsets")
local images = assets.images

local font = graphics.getFont()


local text_to_width = {
 --   [text] = width_in_pixels
}

local text_to_height = {
 --   [text] = height_in_pixels
}


local SCALE = 1/2

local EXTRA_OY = 5



on("drawEntity", function(ent)
    if nametagGroup:has(ent) then
        local ox, oy = quad_offsets(images[ent.image])
        local text = ent.nametag.value or ent.controller or DEFAULT

        local width = text_to_width[text] or font:getWidth(text)
        text_to_width[text] = width

        local height = text_to_height[text] or font:getHeight(text)
        text_to_height[text] = height

        graphics.push("all")
        
        graphics.setColor(0.2,0.2,0.2, 0.5)

        local y = base.getScreenY(ent)

        graphics.rectangle(
            "fill", 
            ent.x + ox/2 - ((width/2) * SCALE),
            y - oy - ((height/2) * SCALE) - EXTRA_OY,
            width * SCALE, height * SCALE
        )

        graphics.setColor(1,1,1)
        graphics.print(
            text, 
            ent.x + ox/2, 
            y - oy - EXTRA_OY,
            ent.rot, SCALE, SCALE,
            width/2, height/2
        )

        graphics.pop()
    end
end)

