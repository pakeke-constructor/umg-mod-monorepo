
local uiTools = require("client.rendering.ui_tools")


local CARD_INFO_WINDOW_X = 30
local CARD_INFO_WINDOW_Y = 30








local function unitStats(etype, rgbColor)
    uiTools.renderBasicUnitInfo(etype, rgbColor)
    Slab.Separator()
    uiTools.renderUnitHealth(etype.defaultHealth)

    if rgb.isSorcerer(etype) then
        -- it's a sorcerer, render sorcery
        uiTools.renderUnitPowerSorcerer(etype.defaultPower)
    elseif rgb.isAttacker(etype) then
        -- it's ranged or melee, which means that attack speed counts
        uiTools.renderUnitPowerAttackSpeed(etype.defaultPower, etype.defaultAttackSpeed)
    end

    Slab.Separator()
    uiTools.renderAbilityInfo(etype.defaultAbilities or {})
end



local function spellStats(etype, rgbColor)
    local col = rgb.rgbToColor(rgbColor)
    local cardInfo = etype.cardInfo
    Slab.Text(cardInfo.name, col)
    Slab.Separator()
    Slab.Text(cardInfo.description)
end



local function drawCardInfo(cardEnt)
    Slab.BeginWindow("cardInfoPopup", {X=CARD_INFO_WINDOW_X, Y=CARD_INFO_WINDOW_Y})
    local etype = cardEnt.cardBuyTarget 
    local rgbColor = cardEnt.rgb

    if rgb.isUnitCard(cardEnt) then
        unitStats(etype, rgbColor)
    elseif rgb.isSpellCard(cardEnt) then
        spellStats(etype, rgbColor)
    else
        error("yo wat")
    end

    Slab.Separator()
    uiTools.renderRGBInfo(rgbColor)
    Slab.EndWindow()
end





local rgbGroup = umg.group("rgb", "rgbCard")


local entBeingHovered = nil

umg.on("slabUpdate", function()
    entBeingHovered = nil
    for _, ent in ipairs(rgbGroup) do
        if ent.rgbTeam == client.getUsername() then
            if base.client.isHovered(ent) then
                drawCardInfo(ent)
                entBeingHovered = ent
            end
        end
    end
end)



umg.on("preDrawUI", function()
    if entBeingHovered then
        love.graphics.push("all")
        love.graphics.setColor(1,1,1,0.3)
        love.graphics.setLineWidth(5)
       
        local x, y = rendering.toScreenCoords(entBeingHovered.x, rendering.getDrawY(entBeingHovered.y, entBeingHovered.z))
        local scale = rendering.getUIScale()
 
        local circle_size = 3 * (2 + math.sin(state.getGameTime() * 3))
        love.graphics.circle("line", x/scale, y/scale, circle_size)
        love.graphics.pop()
    end
end)

