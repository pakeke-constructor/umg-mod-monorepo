

require("shared.rgb")




local generateCards = {}


local function getCardColor(col)
    local cpy = {}
    for i=1, 3 do
        cpy[i] = math.max(constants.CARD_LIGHTNESS, col[i])
    end
    return cpy
end


local rgbSelection = base.weightedRandom({
    -- [result]    =  probability weight
    [rgb.COLS.RED] =   0.3,
    [rgb.COLS.BLU] =   0.3,
    [rgb.COLS.GRN] =   0.3,
    [rgb.COLS.YLO] =   0.05,
    [rgb.COLS.MAG] =   0.05,
    [rgb.COLS.AQU] =   0.05,
})



local itemRGBSelection = base.weightedRandom({
    -- [result]    =  probability weight
    [rgb.COLS.RED] =   0.3,
    [rgb.COLS.BLU] =   0.3,
    [rgb.COLS.GRN] =   0.3,
    [rgb.COLS.YLO] =   0.2,
    [rgb.COLS.MAG] =   0.2,
    [rgb.COLS.AQU] =   0.2,
})


local randomCardEtype

do
local cardPool = {}

for _, etype in pairs(server.entities) do
    if etype.card then
        -- Add this etype to the pool.
        cardPool[etype] = etype.card
    end
end

local rawRandom = base.weightedRandom(cardPool)

function randomCardEtype(turn)
    local cardEtype = rawRandom()
    while (cardEtype.minimumTurn or 1) > turn do 
        cardEtype = rawRandom()
    end
    return cardEtype
end

end




local spawnCardTc = base.typecheck.assert("table", "number")

function generateCards.spawnCard(board, shopIndex)
    spawnCardTc(board, shopIndex)
    local turn = rgb.getTurn()
    local cardEtype = randomCardEtype(turn)
    local x, y = board:getCardXY(shopIndex)

    local cardEnt = server.entities.card(x, y, {
        rgbTeam = board:getTeam(),
        cardInfo = cardEtype.cardInfo,
    })

    cardEnt.image = cardEtype.cardInfo.image or constants.DEFAULT_CARD_IMAGE
    cardEnt.rgb = rgbSelection()
    cardEnt.color = getCardColor(cardEnt.rgb)
    cardEnt.shopIndex = shopIndex
    board.shop[shopIndex] = cardEnt

    return cardEnt
end


return generateCards
