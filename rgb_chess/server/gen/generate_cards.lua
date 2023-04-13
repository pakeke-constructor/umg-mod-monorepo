

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
        error("This entity type is missing some vital info - " .. etypeName)
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
        assertFor(etype.defaultHealth, etypeName)
        -- TODO: Sorcery entities don't have attackDamage;
        -- this should be changed.
        assertFor(etype.defaultAttackDamage, etypeName)
        assertFor(etype.defaultAttackSpeed, etypeName)
    elseif cardInfo.type == constants.CARD_TYPES.SPELL then
        assertFor(cardInfo.spellInfo, etypeName)
    end
end


local randomCardEtype


umg.on("@load", function()
    -- We have to do this within the load function,
    -- because entities aren't loaded yet.
    local cardPool = {}
    for etypeName, etype in pairs(server.entities) do
        if etype.cardInfo then
            -- Add this etype to the pool.
            assertCardInfoOk(etype, etypeName)
            cardPool[etype] = etype.cardInfo.rarity or constants.DEFAULT_CARD_RARITY
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
end)





local spawnCardTc = base.typecheck.assert("table", "number")

function generateCards.spawnCard(board, shopIndex)
    spawnCardTc(board, shopIndex)
    local turn = rgb.getTurn()
    local cardEtype = randomCardEtype(turn)
    local x, y = board:getCardXY(shopIndex)

    local cardEnt = server.entities.card(x, y, {
        rgbTeam = board:getTeam(),
        cardBuyTarget = cardEtype,
        shopIndex = shopIndex
    })

    cardEnt.image = cardEtype.cardInfo.image or constants.DEFAULT_CARD_IMAGE
    cardEnt.rgb = rgbSelection()
    cardEnt.color = getCardColor(cardEnt.rgb)
    board.shop[shopIndex] = cardEnt

    return cardEnt
end


return generateCards
