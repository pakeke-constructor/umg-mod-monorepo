

require("shared.rgb")


--[[

Generates cards for shop rerolls.

]]


local unitTiers = {
}




local genCards = {}


function genCards.getBuyTarget()
end



local function getCardColor(col)
    local cpy = {}
    for i=1, 3 do
        cpy[i] = math.max(constants.CARD_LIGHTNESS, col[i])
    end
    return cpy
end




local earlyRGBSelection = base.weightedRandom({
    -- [result]    =  probability weight
    [rgb.COLS.RED] =    0.3,
    [rgb.COLS.BLU] =    0.3,
    [rgb.COLS.GRN] =    0.3,
    [rgb.COLS.WHI] = 999999999999
})



local RGBSelection = base.weightedRandom({
    -- [result]    =  probability weight
    [rgb.COLS.RED] =   0.3,
    [rgb.COLS.BLU] =   0.3,
    [rgb.COLS.GRN] =   0.3,
    [rgb.COLS.YLO] =   0.05,
    [rgb.COLS.MAG] =   0.05,
    [rgb.COLS.AQU] =   0.05,
    [rgb.COLS.WHI] =   0.03
})



function genCards.getRGB(turn)
    if turn < 4 then
        -- we dont want players to be getting OP colors in early rounds.
        return earlyRGBSelection()
    else
        return RGBSelection()
    end
end



function genCards.spawnCard(board, shopIndex)
    local turn = rgb.getTurn()
    local etype_buyTarget = genCards.getBuyTarget()
    local x, y = board:getCardXY(shopIndex)

    local card_ent = server.entities.card({
        x=x,
        y=y,
        rgbTeam = board:getTeam(),
        cardBuyTarget = etype_buyTarget
    })
    card_ent.rgb = genCards.getRGB(turn)
    card_ent.color = getCardColor(card_ent.rgb)
    card_ent.shopIndex = shopIndex
    board.shop[shopIndex] = card_ent

    if etype_buyTarget.unitCardInfo then
        rgb.setCardType(card_ent, rgb.cardTypes.unit)
    else
        rgb.setCardType(card_ent, rgb.cardTypes.other)
    end

    return card_ent
end


return genCards

