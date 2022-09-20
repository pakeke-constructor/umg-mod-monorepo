
local select = require("client.select")
local showDetails = require("client.show_details")



local WHITE = {1,1,1}
local SAMECOL_OPACITY = 0.95


local function drawSelectTarget(ent)
    if select.isSelected(ent) then
        local t = timer.getTime()
        graphics.push("all")
        graphics.setColor(0,0,0)
        base.drawImage("target", ent.x, ent.y, t, 1.1,1.1)
        base.drawImage("target", ent.x, ent.y, t, 0.9,0.9)
        graphics.setColor(WHITE)
        base.drawImage("target", ent.x, ent.y, t)
        graphics.pop("all")
    elseif rgb.areMatchingColors(ent.rgb, select.getSelectedRGB()) then
        local t = timer.getTime()
        graphics.push("all")
        local c = ent.color
        graphics.setColor(c[1],c[2],c[3],SAMECOL_OPACITY)
        base.drawImage("target", ent.x, ent.y, t, 1.2,1.2)
        graphics.pop("all")
    end
end

local FORMAT = "%.1f"

local TEXT_OY = -30
local TEXT_OX = 10
local OX = 16
local SCALE = (3/4)
local RECT_LEIGH = 4

local TEXT_W = graphics.getFont():getWidth("0.1")
local TEXT_H = graphics.getFont():getHeight("00")

local function drawUnitDetails(ent)
    graphics.push("all")
    graphics.scale(SCALE)
    graphics.setColor(0,0,0,0.5)
    graphics.rectangle("fill", 
        (ent.x-TEXT_OX-RECT_LEIGH-OX)/SCALE,
        (ent.y+TEXT_OY-RECT_LEIGH)/SCALE,
        (RECT_LEIGH*2 + TEXT_OX + TEXT_W)/SCALE,
        (TEXT_H + RECT_LEIGH)/SCALE
    )
    graphics.setColor(0.5,0.1,0.1)
    graphics.print(ent.maxHealth, (ent.x - TEXT_OX-1-OX)/SCALE, (ent.y + TEXT_OY-1)/SCALE)
    graphics.setColor(1,0.2,0.2)
    graphics.print(
        ent.maxHealth, (ent.x - TEXT_OX-OX)/SCALE, (ent.y + TEXT_OY)/SCALE
    )

    graphics.setColor(0.4,0.4,0.1)
    graphics.print(FORMAT:format(
        ent.attackDamage * ent.attackSpeed), 
        (ent.x + TEXT_OX - 1-OX)/SCALE, (ent.y + TEXT_OY-1)/SCALE
    )
    graphics.setColor(0.8,0.8,0.2)
    graphics.print(
        FORMAT:format(ent.attackDamage * ent.attackSpeed), 
        (ent.x + TEXT_OX-OX)/SCALE, (ent.y + TEXT_OY)/SCALE
    )

    graphics.pop("all")
end




on("drawEntity", function(ent)
    if ent.rgb and ent.squadron then
        drawSelectTarget(ent)
        if showDetails.showingDetails() then
            drawUnitDetails(ent)
        end
    end
end)


