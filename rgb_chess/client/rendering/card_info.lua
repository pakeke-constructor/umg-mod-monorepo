
local renderTools = require("client.rendering.render_tools")


local CARD_INFO_WINDOW_X = 30
local CARD_INFO_WINDOW_Y = 30








local function drawUnitCardInfo(cardEnt)
    Slab.BeginWindow("cardInfoPopup", {X=CARD_INFO_WINDOW_X, Y=CARD_INFO_WINDOW_Y})
    local unitEType = cardEnt.cardBuyTarget 
    local rgbColor = cardEnt.rgb

    renderTools.renderBasicUnitInfo(unitEType, cardEnt.rgb)
    
    Slab.Separator()

    renderTools.renderUnitHealth(unitEType.defaultHealth)
    -- TODO: Add support for sorcerers here
    renderTools.renderUnitDamage(unitEType.defaultAttackDamage, unitEType.defaultAttackSpeed)

    Slab.Separator()

    renderTools.renderRGBInfo(rgbColor)

    Slab.EndWindow()
end



local function drawCardInfo(cardEnt)
    drawUnitCardInfo(cardEnt)
    --todo: support for spell cards.
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
       
        local x, y = base.client.camera:toCameraCoords(entBeingHovered.x, base.client.getDrawY(entBeingHovered.y, entBeingHovered.z))
        local scale = base.client.getUIScale()
 
        local circle_size = 3 * (2 + math.sin(base.getGameTime() * 3))
        love.graphics.circle("line", x/scale, y/scale, circle_size)
        love.graphics.pop()
    end
end)

