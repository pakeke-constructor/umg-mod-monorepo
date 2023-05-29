

require("shared.rgb")




local generateCards = {}



local rgbSelection = base.weightedRandom({
    -- [result]    =  probability weight
    [rgb.COLS.RED] =   0.3,
    [rgb.COLS.BLU] =   0.3,
    [rgb.COLS.GRN] =   0.3,
    [rgb.COLS.YLO] =   0.035,
    [rgb.COLS.MAG] =   0.035,
    [rgb.COLS.AQU] =   0.035,
})



local function assertFor(bool, etypeName)
    if not bool then
        error("This entity type is missing some vital info - " .. tostring(etypeName))
    end
end


local function assertUnitInfo(unitInfo, etypeName)
    assertFor(unitInfo, etypeName)
    assertFor(unitInfo.squadronSize, etypeName)
    assertFor(unitInfo.symbol, etypeName)
end

local function assertUnitFields(etype, etypeName)
    assertFor(etype.defaultHealth, etypeName)
    assertFor(etype.unitType, etypeName)
    local UNIT_TYPES = constants.UNIT_TYPES
    assertFor(UNIT_TYPES[etype.unitType], etypeName)

    assertFor(etype.defaultPower, etypeName)
    if etype.unitType == UNIT_TYPES.MELEE or etype.unitType == UNIT_TYPES.RANGED then
        assertFor(etype.defaultAttackSpeed, etypeName)
    end
end



local statComponents = {
    "health", "maxHealth",
    "power", "attackSpeed",
    "abilities"
}


local function assertETypeOk(etype, etypeName)
    local cardInfo = etype.cardInfo
    assertFor(cardInfo, etypeName)
    assertFor(constants.CARD_TYPES[cardInfo.type], etypeName) 
    assertFor(cardInfo.cost, etypeName)
    assertFor(cardInfo.name, etypeName)
    assertFor(cardInfo.description, etypeName)
    assertFor(cardInfo.difficultyLevel, etypeName)
    local diff = cardInfo.difficultyLevel
    assertFor(diff <= constants.MAX_DIFFICULTY_LEVEL and diff >= constants.MIN_DIFFICULTY_LEVEL, etypeName)

    for _, comp in ipairs(statComponents) do
        -- All these components should be regular, not shared
        assertFor(not etype[comp], etypeName)
    end

    if cardInfo.type == constants.CARD_TYPES.UNIT then
        assertUnitInfo(cardInfo.unitInfo, etypeName)
        assertUnitFields(etype, etypeName)
    elseif cardInfo.type == constants.CARD_TYPES.SPELL then
        assertFor(cardInfo.spellCast, etypeName)
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
            assertETypeOk(etype, etypeName)
            cardPool[etype] = etype.cardInfo.rarity or constants.DEFAULT_RARITY
        end
    end

    local rawRandom = base.weightedRandom(cardPool)

    function randomCardEtype(turn)
        local cardEtype = rawRandom()
        while (cardEtype.cardInfo.minimumTurn or 1) > turn do 
            cardEtype = rawRandom()
        end
        return cardEtype
    end
end)





local spawnCardTc = typecheck.assert("table", "number")

function generateCards.spawnCard(board, shopIndex)
    spawnCardTc(board, shopIndex)
    local turn = rgb.getTurn()
    local cardEtype = randomCardEtype(turn)
    local x, y = board:getCardXY(shopIndex)
    assert(board:getTeam(), "?")

    local cardEnt = server.entities.card(x, y, {
        rgbTeam = board:getTeam(),
        cardBuyTarget = cardEtype,
        shopIndex = shopIndex,
        cost = cardEtype.cardInfo.cost
    })

    cardEnt.image = cardEtype.cardInfo.image or constants.DEFAULT_CARD_IMAGE
    cardEnt.rgb = rgbSelection()
    cardEnt.color = rgb.rgbToColor(cardEnt.rgb)
    board.shop[shopIndex] = cardEnt

    return cardEnt
end


return generateCards
