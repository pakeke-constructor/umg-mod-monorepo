

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


local fontScale = 1/3






local function drawUnitCard(ent)
    local x, y = ent.x, ent.y
    if base.isHovered(ent) then
        y = y + MOUSE_HOVER_OY
    end
    local unitEType = ent.cardBuyTarget
    local unitCardInfo = unitEType.unitCardInfo

    graphics.push("all")
    graphics.setColor(ent.color)
    base.drawImage("unit_card", x, y)
    
    graphics.setColor(0.2,0.2,0.2)
    graphics.print(
        unitCardInfo.name, x + UNIT_NAME_OX, y + UNIT_NAME_OY,
        0,fontScale,fontScale
    )
    
    local health = unitEType.defaultHealth
    local damageEstimate = rgb.getDamageEstimate(unitEType.defaultAttackDamage, unitEType.defaultAttackSpeed)
    local damage = ("%.1f"):format(damageEstimate)
    local color_str = rgb.getColorString(ent.rgb)
    local description = unitCardInfo.description:gsub(constants.COLOR_SUB_TAG, color_str)

    assert(unitCardInfo.cost,"?")
    local cost = "$" .. tostring(ent.cost)

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
        description, 
        (x + UNIT_NAME_OX) / fontScale, 
        (y + DESCRIPTION_OY) / fontScale,
        160, "left"
    )
    
    graphics.pop()
end





local healthTextArgs = {Color = {1,0.2,0.2}}
local dmgTextArgs = {Color = {0.8,0.7,0.1}}
local descTextArgs = {Color = {0.6,0.6,0.6}}

local function drawUnitInfo(ent)
    Slab.BeginWindow("unitInfo", {X=90, Y=90})
    local unitEType
    if ent.cardBuyTarget then
        unitEType = ent.cardBuyTarget
    else
        unitEType = ent:getClass()
    end
    local unitCardInfo = unitEType.unitCardInfo

    Slab.Text(unitCardInfo.name)
    
    Slab.Separator()

    Slab.Text("Health: " .. unitEType.defaultHealth, healthTextArgs)

    local damageEstimate = rgb.getDamageEstimate(unitEType.defaultAttackDamage, unitEType.defaultAttackSpeed)
    local damage = ("%.1f"):format(damageEstimate)
    Slab.Text("DPS:    " .. damage, dmgTextArgs)

    local color_str = rgb.getColorString(ent.rgb)
    Slab.Text("RGB: ")
    Slab.SameLine()
    Slab.Text(color_str, {Color=ent.rgb})

    Slab.Text(" ")

    local f = graphics.getFont()
    local description = unitCardInfo.description:gsub(constants.COLOR_SUB_TAG, color_str)
    local _, txt_table = f:getWrap(description, 600)
    for _, txt in ipairs(txt_table) do
        Slab.Text(txt)
    end

    Slab.EndWindow()
end





local function drawSpellCard(ent)
    graphics.push("all")
    base.drawImage("spell_card", ent.x, ent.y)
    graphics.pop()
end




local function drawCard(ent)
    if ent.x and ent.y then
        if rgb.isUnitCard(ent) then
            drawUnitCard(ent)
        else
            drawSpellCard(ent)
        end
    end
end


on("gameUpdate",function(dt)
    currentTime = currentTime + dt
end)

on("drawEntity", function(ent)
    if ent.cardBuyTarget then
        if rgb.state == rgb.STATES.TURN_STATE then
            drawCard(ent)
        end
    end
end)




local rgbGroup = group("rgb")


on("mainDrawUI", function()
    for _, ent in ipairs(rgbGroup) do
        if ent.rgbTeam == username then
            if base.isHovered(ent) then
                --[[
                local x, y = mouse.getPosition()
                local uiscale = base.getUIScale()
                x,y = x/uiscale, y/uiscale
                ]]
                drawUnitInfo(ent)
            end
        end
    end
end)

