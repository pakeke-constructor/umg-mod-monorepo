
local font = love.graphics.getFont()


local DCOL = 0.4
local WHITE = {1,1,1}


umg.on("drawEntity", function(ent)
    --[[
        text = {
            value = "hello",
            ox = 10,
            oy = 9,
            scale = 1,
            overlay = true,
            color = {1,1,1}
        }
    ]]
    if ent.text then
        local text = ent.text
        local val = tostring(text.value)

        local scale = (text.scale or 1) * (ent.scale or 1)

        local width = font:getWidth(val)
        local height = font:getHeight(val)

        local text_ox = text.ox or 0
        local text_oy = text.oy or 0
        
        love.graphics.push("all")
    
        local y = base.client.getDrawY(ent.y,ent.z)

        local color = text.color or ent.color or WHITE

        if text.overlay then
            love.graphics.setColor(color[1]-DCOL,color[2]-DCOL,color[3]-DCOL)
            
            love.graphics.print(
                val, 
                ent.x + text_ox - 1, 
                y + text_oy - 1,
                ent.rot, scale, scale,
                width/2, height/2
            )
        end

        love.graphics.setColor(color)
        love.graphics.print(
            val, 
            ent.x + text_ox, 
            y + text_oy,
            ent.rot, scale, scale,
            width/2, height/2
        )

        love.graphics.pop()
    end
end)

