

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


local function assertFor(bool, etypeName)
    if not bool then
        error("cardInfo is missing something for this entity type: " .. etypeName)
    end
end

local function assertUnitInfo(unitInfo, etypeName)
    assertFor(unitInfo, etypeName)
    assertFor(unitInfo.squadronSize)
end

local function assertCardInfoOk(etype, etypeName)
    local cardInfo = etype.cardInfo
    assertFor(constants.CARD_TYPES[cardInfo.type], etypeName) 
    assertFor(cardInfo.cost, etypeName)
    assertFor(cardInfo.name, etypeName)
    assertFor(cardInfo.description, etypeName)

    if cardInfo.type == constants.CARD_TYPES.UNIT then
        assertUnitInfo(cardInfo.unitInfo, etypeName)
    elseif cardInfo.type == constants.CARD_TYPES.SPELL then
        assertFor(cardInfo.spellInfo, etypeName)
    end
end


local randomCardEtype

do
local cardPool = {}

for _, etype in pairs(server.entities) do
    if etype.cardInfo then
        -- Add this etype to the pool.
        assertCardInfoOk(etype)
        cardPool[etype] = etype
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
