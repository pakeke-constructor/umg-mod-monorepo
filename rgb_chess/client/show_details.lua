


local select = require("client.select")



local showDetails = {}


local showingDetails = false


function showDetails.showDetails()
    showingDetails = true
end


function showDetails.hideDetails()
    showingDetails = false
end

function showDetails.showingDetails()
    return showingDetails
end




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
local TEXT_OX = 10 -- distance between attack and health stats
local SCALE = (3/4)
local RECT_LEIGH = 4

local TEXT_W = graphics.getFont():getWidth("0")
local TEXT_H = graphics.getFont():getHeight("0")



local function prettyPrint(str, x, y, color, scale)
    graphics.setColor(color[1]/2,color[2]/2,color[3]/2)
    graphics.print(str, (x-1)/scale, (y-1)/scale)
    graphics.setColor(color)
    graphics.print(str, x/scale, y/scale)
end


local function drawUnitDetails(ent)
    graphics.push("all")
    graphics.scale(SCALE)
    graphics.setColor(0,0,0,0.5)

    local maxHealthStr = FORMAT:format(ent.maxHealth)
    local damageEstStr = FORMAT:format(rgb.getDamageEstimate(ent.attackDamage, ent.attackSpeed))
    local mhsLen = #maxHealthStr
    local desLen = #damageEstStr

    local strW = TEXT_W * (mhsLen + desLen)

    graphics.rectangle("fill", 
        (ent.x - strW/2-RECT_LEIGH)/SCALE,
        (ent.y+TEXT_OY-RECT_LEIGH)/SCALE,
        (RECT_LEIGH + TEXT_OX + strW)/SCALE,
        (TEXT_H + RECT_LEIGH)/SCALE
    )

    prettyPrint(
        damageEstStr,
        ent.x - strW/2, 
        ent.y + TEXT_OY,
        {0.8,0.8,0.2},
        SCALE
    )

    prettyPrint(
        maxHealthStr, 
        ent.x - strW/2 + TEXT_OX + (desLen*TEXT_W), 
        ent.y + TEXT_OY, 
        {1,0.2,0.2}, 
        SCALE
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





return showDetails

