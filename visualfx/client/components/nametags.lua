

local DEFAULT = "UNNAMED"

local images = client.assets.images

local font = love.graphics.getFont()


local text_to_width = {
 --   [text] = width_in_pixels
}

local text_to_height = {
 --   [text] = height_in_pixels
}


local SCALE = 1/2

local EXTRA_OY = 10



local function getNametagText(ent)
    if ent.nametag.value then
        return ent.nametag.value
    end

    local txt = umg.ask("getNametagText", reducers.PRIORITY, ent)

    return (txt or ent.controller) or DEFAULT
end


umg.on("postDrawEntity", function(ent)
    if ent.nametag then
        local _ox, oy = rendering.getImageOffsets(images[ent.image])
        local text = getNametagText(ent)
        local width = text_to_width[text] or font:getWidth(text)
        text_to_width[text] = width

        local height = text_to_height[text] or font:getHeight(text)
        text_to_height[text] = height

        love.graphics.push("all")
        
        love.graphics.setColor(0.2,0.2,0.2, 0.5)

        local y = rendering.getDrawY(ent.y,ent.z)

        love.graphics.rectangle(
            "fill", 
            ent.x - (width/2) * SCALE,
            y - oy - (height/2) * SCALE - EXTRA_OY,
            width * SCALE, height * SCALE
        )

        love.graphics.setColor(1,1,1)
        love.graphics.print(
            text, 
            ent.x, 
            y - oy - EXTRA_OY,
            ent.rot, SCALE, SCALE,
            width/2, height/2
        )

        love.graphics.pop()
    end
end)

