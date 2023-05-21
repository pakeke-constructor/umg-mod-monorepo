
local Board = require("server.board")

local abilities = require("server.abilities.abilities")
local spawn = require("server.shop.spawn_entity")



local buy = {}



local function spawnUnitFromCard(card_ent)
    -- spawns a squadron from a card.
    -- spawnX, spawnY default to random position.
    local unit_etype = card_ent.cardBuyTarget

    local ent = spawn.spawn(unit_etype, {
        rgbTeam = card_ent.rgbTeam,
        rgb = card_ent.rgb,
        color = card_ent.color
    })

    return ent
end



local function buyUnitCard(card_ent)
    --[[
        buys a squadron described by a card.
    ]]
    local squadron = {}
    local unit_etype = card_ent.cardBuyTarget
    local info = unit_etype.cardInfo
    local numUnits = info.squadronSize or 1
    for _=1, numUnits do
        local ent = spawn.spawnUnitFromCard(card_ent)
        ent.squadron = squadron
        table.insert(squadron, ent)
    end
    for _, ent in ipairs(squadron) do
        umg.call("buyUnit", ent)
    end
end



local function buySpellCard(card_ent)

end



function buy.buyCard(card_ent, cost)
    local board = Board.getBoard(card_ent.rgbTeam)
    cost = cost or buy.getCost(card_ent)

    local etype = card_ent.cardBuyTarget
    local typ = etype.cardInfo.type 
    if typ == constants.CARD_TYPES.UNIT then
        buyUnitCard(card_ent)
    elseif typ == constants.CARD_TYPES.SPELL then
        buySpellCard(card_ent)
    end

    board:setMoney(board:getMoney() - cost)
end


function buy.getCost(card_ent)
    return card_ent.cost
end



function buy.canBuy(card_ent)
    local board = rgb.getBoard(card_ent.rgbTeam)
    local etype = card_ent.cardBuyTarget

    if rgb.state ~= rgb.STATES.TURN_STATE then
        return false
    end

    if buy.getCost(card_ent) > board:getMoney() then
        return false -- too expensive
    end

    if etype.cardInfo.type == constants.CARD_TYPES.UNIT then
        if rgb.getMaxSquadrons() <= board:getSquadronCount() then
            -- if board is full, disallow
            return false
        end
    end

    return true
end




local function sellUnit(ent)
    abilities.trigger("allySold", ent.rgbTeam)
    umg.call("sellUnit", ent)
    ent:delete()
end


function buy.sellSquadron(ent)
    umg.call("sellSquadron", ent.squadron)
    local cost = ent.cardInfo.cost
    assert(ent.squadron,"?")
    local board = Board.getBoard(ent.rgbTeam)
    board:setMoney(board:getMoney() + cost)
    for _, e in ipairs(ent.squadron)do
        sellUnit(e)
    end
end




local function isUnitEntity(ent, sender)
    if not umg.exists(ent) then
        return false
    end
    if not ent.squadron then
        return false
    end
    if ent.rgbTeam ~= sender then
        return false
    end
    return true
end



server.on("sellSquadron", {
    arguments = {isUnitEntity},
    handler = function(sender, ent)
    local board = Board.getBoard(sender)
    if board then
        buy.sellSquadron(ent)
    end
end})



return buy

