
--[[


TODO:
Conver this to Slab UI.



]]

local F2 = "%.2f"

local font = love.graphics.getFont()
local H = font:getHeight("bjA") -- pretty arbitrarly letters, doesnt matter tbh

local setCol = love.graphics.setColor

local WIDTH = 50
local RECT_BORDER = 10


local function drawUnitStats(ent, x, y)
    assert(ent.cardType and server.entities[ent.cardType], "?")
    local card_ent = server.entities[ent.cardType]
    
    local health = F2:format(ent.health)
    local dmg = F2:format(ent.attackDamage)
    local atckSpeed = F2:format(ent.attackSpeed)
    local speed = F2:format(ent.speed)

    love.graphics.push("all")

    local _, wrappedtext = font:getWrap(card_ent.card.description, WIDTH)
    local _, newlineCount = string.gsub(wrappedtext, "\n", "")
    wrappedtext:gsub("%[color%]", rgb.getColorString(ent.rgb))

    local dy = H + 1
    local height = (dy*5) + (dy*newlineCount)

    setCol(ent.color)
    love.graphics.rectangle(
        "fill", x-RECT_BORDER, y-RECT_BORDER, 
        WIDTH+RECT_BORDER*2,height+RECT_BORDER*2,
        RECT_BORDER/2,RECT_BORDER/2
    )

    setCol(ent.color[1]/2,ent.color[2]/2,ent.color[3]/2)
    love.graphics.rectangle(
        "line", x-RECT_BORDER, y-RECT_BORDER, 
        WIDTH+RECT_BORDER*2,height+RECT_BORDER*2,
        RECT_BORDER/2,RECT_BORDER/2
    )

    setCol(0.3,0.05,0.05)
    love.graphics.print("health :   " .. tostring(health), x, y)
    setCol(0.2,0.1,0.05)
    love.graphics.print("damage :   " .. tostring(dmg), x, y + dy)
    setCol(0.2,0.1,0.05)
    love.graphics.print("atk spd:   " .. tostring(atckSpeed), x, y + dy*2)
    setCol(0.05,0.05,0.3)
    love.graphics.print("mov spd: " .. tostring(speed), x, y + dy*3)

    setCol(0.2,0.2,0.2)
    love.graphics.printf(wrappedtext, x, y + dy*5)

    love.graphics.pop()
end


return drawUnitStats

