
local font = love.graphics.getFont()


local DCOL = 0.4
local WHITE = {1,1,1}

local DEFAULT_BG_BORDER = 2


local PRIO = -1


local function getText(ent)
    local text = ent.text
    if text.value then
        return text.value
    end

    if text.getText then
        return text.getText(ent)
    end

    if text.component and ent[text.component] then
        return ent[text.component]
    end

    if text.default then
        return text.default 
    end

    error("Text component has no .value, for entity: " .. tostring(ent:type()))
end



umg.on("rendering:drawEntity", function(ent)
    --[[
        text = {
            value = "hello",
            ox = 10,
            oy = 9,
            scale = 1,
            overlay = true,
            color = {1,1,1}
            background = {0,0,0,0.4} -- background box thing
        }
    ]]
    if not ent.text then
        return
    end

    local text = ent.text
    local val = getText(ent)

    local scale = (text.scale or 1) * (ent.scale or 1)

    local width = font:getWidth(val)
    local height = font:getHeight(val)

    local text_ox = text.ox or 0
    local text_oy = text.oy or 0
    
    love.graphics.push("all")

    local y = rendering.getDrawY(ent.y,ent.z)

    local color = text.color or ent.color or WHITE

    if text.background then
        local border = text.backgroundBorder or DEFAULT_BG_BORDER
        local xx = ent.x + (text_ox - width/2 - border) * scale
        local yy = y + (text_oy - height/2 - border) * scale
        local ww = (width + border*2) * scale
        local hh = (height + border*2) * scale
        love.graphics.rectangle("fill", xx, yy, ww, hh)
    end

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
end, PRIO)

