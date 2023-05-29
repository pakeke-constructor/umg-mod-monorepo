

local SYMBOL_Y_DELTA = 14



local function drawCard(cardEnt)
    local unitEType = cardEnt.cardBuyTarget
    local cardInfo = unitEType.cardInfo
    if cardInfo.unitInfo then
        -- draw symbol
        love.graphics.setColor(0,0,0, constants.UNIT_SYMBOL_ALPHA)
        base.client.drawImage(cardInfo.unitInfo.symbol, cardEnt.x, cardEnt.y + SYMBOL_Y_DELTA, 0,2,2)
    end
end




umg.on("drawEntity", function(ent)
    if rgb.state == rgb.STATES.TURN_STATE then
        if ent.cardBuyTarget then
            drawCard(ent)
        end
    end
end)

