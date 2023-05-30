

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


local function lockBelongsToCard(lockEnt, cardEnt)
    return lockEnt.rgbTeam == cardEnt.rgbTeam
        and lockEnt.shopIndex == cardEnt.shopIndex
end



local cardLockGroup = umg.group("rgbCardLock")

umg.answer("getOpacity", function(ent)
    -- this is a bit hacky and bad, oh well tho
    if ent.rgbCard then
        for _, cardLockEnt in ipairs(cardLockGroup) do
            if lockBelongsToCard(cardLockEnt, ent) then
                if cardLockEnt.isLocked then
                    return constants.CARD_LOCK_OPACITY
                end
            end
        end
    end
    return 1
end)




umg.on("drawEntity", function(ent)
    if rgb.state == rgb.STATES.TURN_STATE then
        if ent.cardBuyTarget then
            drawCard(ent)
        end
    end
end)

