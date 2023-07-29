

local SYMBOL_Y_DELTA = 14



local function drawCard(cardEnt)
    local unitEType = cardEnt.cardBuyTarget
    local cardInfo = unitEType.cardInfo
    if cardInfo.unitInfo then
        -- draw symbol
        love.graphics.setColor(0,0,0, constants.UNIT_SYMBOL_ALPHA)
        rendering.drawImage(cardInfo.unitInfo.symbol, cardEnt.x, cardEnt.y + SYMBOL_Y_DELTA, 0,2,2)
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




-- how much health and power scale with size
local POWER_SIZE_SCALE_RATE = 0.5
local HEALTH_SIZE_SCALE_RATE = 1

local function getUnitSize(ent)
    local hp_diff = (ent.health - ent.defaultHealth) * HEALTH_SIZE_SCALE_RATE
    local pow_diff = (ent.power - ent.defaultPower) * POWER_SIZE_SCALE_RATE

    local scale = math.max(1, math.sqrt(hp_diff + pow_diff))
    return scale
end


--[[
    units get bigger if they are more powerful
]]
umg.answer("rendering:getScale", function(ent)
    if rgb.isUnit(ent) then
        return getUnitSize(ent)
    end
    return 1
end)



umg.on("rendering:drawEntity", function(ent)
    if rgb.state == rgb.STATES.TURN_STATE then
        if ent.cardBuyTarget then
            drawCard(ent)
        end
    end
end)

