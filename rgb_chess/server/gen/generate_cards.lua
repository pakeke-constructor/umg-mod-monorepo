

require("shared.rgb")


--[[

Generates cards for shop rerolls.

]]


local tiers = {
    [1] = {
        "card_brute"
    },

    [2] = {

    }, 

    [3] = {

    },

    [4] = {

    }
}




local genCards = {}


function genCards.getBuyTarget()
    local turn = rgb.getTurn()
    return entities.brute
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
    [rgb.COLS.GRN] =    0.3
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


function genCards.spawnCard(board, i, numSquadrons)
    local turn = rgb.getTurn()
    local etype = genCards.getCard()
    local x, y = board:getCardXY(i)
    local ent = entities.card(x, y)
    ent.rgbTeam = board:getTeam()
    ent.rgb = genCards.getRGB(turn)
    ent.color = getCardColor(ent.rgb)
    ent.shopIndex = i
    board.shop[i] = ent
    return ent
end


return genCards

