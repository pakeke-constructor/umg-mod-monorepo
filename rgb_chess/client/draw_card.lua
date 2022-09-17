

-- ignore the magic numbers, they just "work" 
-- (They are to do with the dimensions of the card sprites.)
local UNIT_NAME_OY = -43
local UNIT_NAME_OX = -26

local UNIT_INFO_OY = -26
local UNIT_INFO_OX1 = -26
local UNIT_INFO_OX2 = -6
local UNIT_INFO_OX3 = 16

local DESCRIPTION_OY = -9

local MOUSE_HOVER_OY = -15


local currentTime = 0

local BOB_PERIOD = 17
local BOB_AMPL = 8
local PI2 = math.pi * 2


local fontScale = 1/3


local function getBob(ent)
    -- for cards bobbing up and down
    local sin_bob_offset = (ent.id % 6) / BOB_PERIOD
    local sinval = math.sin(PI2 * currentTime / BOB_PERIOD + sin_bob_offset)
    return math.floor(sinval * BOB_AMPL)
end





local function drawUnitCard(ent)
    local x, y = ent.x, ent.y + getBob(ent)
    if base.isHovered(ent) then
        y = y + MOUSE_HOVER_OY
    end
    local card = ent.card
    local unit = card.unit

    graphics.push("all")
    graphics.setColor(ent.color)
    base.drawImage("unit_card", x, y)
    
    graphics.setColor(0.2,0.2,0.2)
    graphics.print(
        card.name, x + UNIT_NAME_OX, y + UNIT_NAME_OY,
        0,fontScale,fontScale
    )
    
    local health = unit.health or "NA"
    local damage = unit.damage or "NA"
    local cost = "$" .. tostring(card.cost or 1)

    graphics.setColor(0.3, 0.1, 0.1)
    graphics.print(
        tostring(health), x + UNIT_INFO_OX1, y + UNIT_INFO_OY,
        0,fontScale,fontScale
    )
    graphics.setColor(0.25, 0.25, 0.05)
    graphics.print(
        tostring(damage), x + UNIT_INFO_OX2, y + UNIT_INFO_OY,
        0,fontScale,fontScale
    )
    graphics.setColor(0.1, 0.3, 0.1)
    graphics.print(
        tostring(cost), x + UNIT_INFO_OX3, y + UNIT_INFO_OY,
        0,fontScale,fontScale
    )

    graphics.setColor(0.1,0.1,0.1)
    graphics.scale(fontScale)
    graphics.printf(
        ent.card.description, 
        (x + UNIT_NAME_OX) / fontScale, 
        (y + DESCRIPTION_OY) / fontScale,
        100, "left"
    )
    
    graphics.pop()
end


local function drawSpellCard(ent)
    base.drawImage("spell_card", ent.x, ent.y)
end


local function drawCard(ent)
    local card = ent.card

    if ent.x and ent.y then
        if card.unit then
            drawUnitCard(ent)
        else
            drawSpellCard(ent)
        end
    end
end


on("update",function()
    currentTime = timer.getTime()
end)

on("drawEntity", function(ent)
    if ent.card then
        if rgb.state == rgb.STATES.TURN_STATE then
            drawCard(ent)
        end
    end
end)

