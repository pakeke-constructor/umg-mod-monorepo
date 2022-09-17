


--[[
OK:::
What stats do we need to show??

Hp
Dmg
attackSpeed

RGB Color components

Description


]]

local F2 = "%.2f"
--[[
local font = graphics.getFont()
local H = font:getHeight("bjA")


local function drawUnitStats(ent, x, y)
    assert(ent.cardType and entities[ent.cardType], "?")
    local card_ent = entities[ent.cardType]
    
    local health = F2:format(ent.health)
    local dmg = F2:format(ent.attackDamage)
    local atckSpeed = F2:format(ent.attackSpeed)
    local speed = F2:format(ent.speed)

    graphics.push("all")

    local dy = H + 1
    
    graphics.print("health :   " .. tostring(health), x, y)
    graphics.print("damage :   " .. tostring(dmg), x, y + dy)
    graphics.print("atk spd:   " .. tostring(atckSpeed), x, y + dy*2)
    graphics.print("mov spd: " .. tostring(speed), x, y + dy*3)

    -- TODO: do all of this
    -- What about importing Slab to the base mod,
    -- and using Slab to display this info?
    -- That sounds like a good idea
    local width, wraptxt = width, wrappedtext = Font:getWrap( text, wraplimit )

    graphics.printf("")

    graphics.pop()
end


return drawUnitStats

]]
