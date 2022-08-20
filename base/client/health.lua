


client.on("changeEntHealth",function(ent, health, maxHealth)
    ent.health = health
    ent.maxHealth = maxHealth
end)


client.on("dead", function(ent)
    call("dead",ent)
end)




--[[

drawing health bars:

]]

local DEFAULT_DRAW_HEIGHT = 5
local DEFAULT_DRAW_WIDTH = 20

local DEFAULT_OFFSET_Y = 10

local DEFAULT_HEALTH_COLOR = {1,0.2,0.2}
local DEFAULT_OUTLINE_COLOR = {0,0,0}
local DEFAULT_BACKGROUND_COLOR = {0.4,0.4,0.4,0.4}



on("drawEntity", function(ent)
    if ent.healthBar and ent.health then
        -- draw the healthbar!
        local hb = ent.healthBar
        local w = hb.drawWidth or DEFAULT_DRAW_WIDTH
        local h = hb.drawHeight or DEFAULT_DRAW_HEIGHT
        local oy = hb.offset or DEFAULT_OFFSET_Y
        local hcol = hb.healthColor or hb.color or DEFAULT_HEALTH_COLOR
        local ocol = hb.outlineColor or DEFAULT_OUTLINE_COLOR
        local bgcol = hb.backgroundColor or DEFAULT_BACKGROUND_COLOR
        
        graphics.push("all")

        graphics.setLineWidth(1)
        local x = ent.x - w/2
        local y = ent.y - h/2 - oy

        graphics.setColor(bgcol) -- background
        graphics.rectangle("fill", x, y, w, h)
        
        -- health bar:
        local ratio = ent.health / (ent.maxHealth or 0xfffffffff)
        graphics.setColor(hcol)
        graphics.rectangle("fill", x, y, w * ratio, h)

        -- outline of health bar:
        graphics.setColor(ocol)
        graphics.rectangle("line", x, y, w, h)

        graphics.pop()
    end
end)


