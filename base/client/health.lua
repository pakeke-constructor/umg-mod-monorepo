


client.on("changeEntHealth",function(ent, health, maxHealth)
    ent.health = health
    ent.maxHealth = maxHealth
end)



--[[

drawing health bars:

]]

local sqrt = math.sqrt

local DEFAULT_DRAW_HEIGHT = 5
local DEFAULT_DRAW_WIDTH = 20

local DEFAULT_OFFSET_Y = 10

local DEFAULT_HEALTH_COLOR = {1,0.2,0.2}
local DEFAULT_OUTLINE_COLOR = {0,0,0}
local DEFAULT_BACKGROUND_COLOR = {0.4,0.4,0.4,0.4}


umg.on("drawEntity", function(ent)
    if ent.healthBar and ent.health then
        -- draw the healthbar!
        local hb = ent.healthBar
        local w = hb.drawWidth or DEFAULT_DRAW_WIDTH
        local h = hb.drawHeight or DEFAULT_DRAW_HEIGHT
        local oy = hb.offset or DEFAULT_OFFSET_Y
        local hcol = hb.healthColor or hb.color or DEFAULT_HEALTH_COLOR
        local ocol = hb.outlineColor or DEFAULT_OUTLINE_COLOR
        local bgcol = hb.backgroundColor or DEFAULT_BACKGROUND_COLOR
        
        love.graphics.push("all")

        love.graphics.setLineWidth(1)
        local x = ent.x - w/2
        local y = ent.y - h/2 - oy

        love.graphics.setColor(bgcol) -- background
        love.graphics.rectangle("fill", x, y, w, h)
        
        -- health bar:
        local ratio = ent.health / (ent.maxHealth or 0xfffffffff)
        love.graphics.setColor(hcol)
        love.graphics.rectangle("fill", x, y, w * ratio, h)

        if hb.shiny then
            love.graphics.setColor(sqrt(hcol[1])+0.1, sqrt(hcol[2])+0.1, sqrt(hcol[3])+0.1)
            love.graphics.rectangle("fill", x, y, w * ratio, h/2)
        end

        -- outline of health bar:
        love.graphics.setColor(ocol)
        love.graphics.rectangle("line", x, y, w, h)

        love.graphics.pop()
    end
end)


