
local Board = require("server.board")

local spawnEntity = require("server.spawn_entity")




local buy = {}





local function spawnUnit(card_ent)
    --[[
        spawns a unit described by a card.
    ]]
    
    local unit = card_ent.card.unit
    assert(entities[unit.type], "invalid unit type: " .. unit.type)
    
    local squadron = {}
    local numUnits = unit.amount or 1
    for _=1, numUnits do
        local ent = spawnEntity.spawnEntityFromCard(card_ent)
        table.insert(squadron, ent)
        ent.squadron = squadron
        ent.cardType = card_ent:type()
        call("buyUnit", ent)
    end
    -- TODO: Do feedback and stuff here.
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
    local baseCost = card_ent.card.baseCost
    if card_ent.card.unit then
        return unitPriceFunction(baseCost, squadronCount)
    else
        return card_ent.card.baseCost
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




function buy.buyCard(card_ent)
    local cost = card_ent.cost
    assert(cost, "what? : " .. card_ent:type())
    local board = Board.getBoard(card_ent.rgbTeam)
    assert(card_ent.shopIndex)

    if card_ent.card.unit then
        spawnUnit(card_ent)
    end

    board:setMoney(board:getMoney() - cost)

    --[[
        this is terrible code!
        We intentially wait 0.2 seconds here, because the unit/s are still spawning.
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
    local cost = card_ent.card.cost or 1
    local board = Board.getBoard(card_ent.rgbTeam)
    if cost <= board:getMoney() then
        buy.buyCard(card_ent)
        return true
    end
end




local function sellUnit(ent)
    call("sellUnit", ent)
    ent:delete()
end


function buy.sellSquadron(ent)
    call("sellSquadron", ent.squadron)
    local ctype = entities[ent.cardType]
    local baseCost = ctype.card.baseCost
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

