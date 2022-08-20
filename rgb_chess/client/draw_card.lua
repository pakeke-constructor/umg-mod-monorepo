

-- ignore the magic numbers, they just "work" 
-- (They are to do with the dimensions of the card sprites.)
local UNIT_NAME_OY = -43
local UNIT_NAME_OX = -26

local UNIT_INFO_OY = -26
local UNIT_INFO_OX1 = -26
local UNIT_INFO_OX2 = -6
local UNIT_INFO_OX3 = 16

local currentTime = 0

local BOB_PERIOD = 3
local BOB_AMPL = 8
local PI2 = math.pi * 2


local fontScale = 1/3


local function getBob(ent)
    -- for cards bobbing up and down
    local sin_bob_offset = (ent.id % 6) / BOB_PERIOD
    local sinval = math.sin(PI2 * currentTime / BOB_PERIOD + sin_bob_offset)
    return sinval * BOB_AMPL
end


local function drawUnitCard(ent)
    local x, y = ent.x, ent.y
    local card = ent.card
    local unit = card.unit

    y = y + getBob(ent)

    graphics.push("all")
    base.drawImage("unit_card", x, y)
    
    graphics.setColor(0.2,0.2,0.2)
    graphics.print(
        card.name, x + UNIT_NAME_OX, y + UNIT_NAME_OY,
        0,fontScale,fontScale
    )
    
    local health = unit.health or "NA"
    local damage = unit.damage or "NA"
    local cost = card.cost or 1

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


on("drawEntity", function(ent)
    currentTime = timer.getTime()
    if ent.card then
        drawCard(ent)
    end
end)

