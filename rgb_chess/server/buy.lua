
local Board = require("server.board")

local spawnEntity = require("server.spawn_entity")



local buy = {}


local function isUnitCard(card_ent)
    -- retures true if `card_ent` is spawning a unit,
    -- false otherwise.
    return card_ent.isUnitCard
end



local function unitPriceFunction(baseCardPrice, numSquadrons)
    -- price function for unit cards.
    return baseCardPrice + numSquadrons
end





function buy.getCost(card_ent, squadronCount)
    --[[
        unit card costs will increase linearly with respect to the number
        of squadrons on the board.
    ]]
    assert(card_ent.rgbTeam, "not given rgbTeam")
    squadronCount = squadronCount or rgb.getSquadronCount(card_ent.rgbTeam)
    
    if isUnitCard(card_ent) then
        local info = card_ent.cardBuyTarget.unitCardInfo
        return unitPriceFunction(info.cost)
    else
        local info = card_ent.cardBuyTarget.otherCardInfo
        assert(info.cost, "?")
        return info.cost
    end
end



function buy.setCosts(rgbTeam)
    -- sets the card costs appropriately for the board owned by rgbTeam.
    local ct = rgb.getSquadronCount(rgbTeam)
    local board = Board.getBoard(rgbTeam)
    for i=1, #board.shop do
        local card = board.shop[i]
        if exists(card) then
            card.cost = buy.getCost(card, ct)
            server.broadcast("setRGBCardCost", card, card.cost)
        end
    end
end



function buy.changeCosts(rgbTeam, dCost)
    -- changes all card costs by a flat amount.
    local board = Board.getBoard(rgbTeam)
    for i=1, #board.shop do
        local card = board.shop[i]
        if exists(card) then
            card.cost = card.cost + dCost
            server.broadcast("setRGBCardCost", card, card.cost)
        end
    end
end



local function buyUnitCard(card_ent)
    --[[
        buys a squadron described by a card.
    ]]
    local squadron = {}
    local unit_etype = card_ent.cardBuyTarget
    local info = unit_etype.unitCardInfo
    local numUnits = info.squadronSize or 1
    for _=1, numUnits do
        local ent = spawnEntity.spawnUnitFromCard(card_ent)
        table.insert(squadron, ent)
        ent.squadron = squadron
        call("buyUnit", ent)
    end
    -- TODO: Do feedback and stuff here.
end



local function buyOtherCard(card_ent)

end



function buy.buyCard(card_ent, cost)
    local board = Board.getBoard(card_ent.rgbTeam)
    cost = cost or buy.getCost(card_ent)
    if isUnitCard(card_ent) then
        buyUnitCard(card_ent)
    else
        buyOtherCard(card_ent)
    end
    board:setMoney(board:getMoney() - cost)

    --[[
    this is lowkey terrible code!
    We intentially wait 0.2 seconds here, because unit(s) might still be spawning.
        (They will be officially spawned in next frame.)
    ]]
    base.delay(0.2, buy.setCosts, card_ent.rgbTeam)
end




function buy.tryBuy(card_ent)
    --[[
        tries to buy a card entity
    ]]
    if rgb.state ~= rgb.STATES.TURN_STATE then
        return 
    end

    local cost = buy.getCost(card_ent)
    local board = Board.getBoard(card_ent.rgbTeam)
    if cost <= board:getMoney() then
        buy.buyCard(card_ent, cost)
        return true
    end
end




local function sellUnit(ent)
    call("sellUnit", ent)
    ent:delete()
end


function buy.sellSquadron(ent)
    call("sellSquadron", ent.squadron)
    local baseCost = ent.unitCardInfo.cost
    assert(ent.squadron,"?")
    local board = Board.getBoard(ent.rgbTeam)
    board:setMoney(board:getMoney() - baseCost)
    for _, e in ipairs(ent.squadron)do
        sellUnit(e)
    end
end


server.on("sellSquadron", function(sender, ent)
    if not exists(ent) then
        return
    end
    if not ent.squadron then
        return
    end
    if ent.rgbTeam ~= sender then
        return
    end

    local board = Board.getBoard(sender)
    if board then
        buy.sellSquadron(ent)
    end
end)



return buy

