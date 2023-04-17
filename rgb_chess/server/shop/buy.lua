
local Board = require("server.board")

local spawn = require("server.shop.spawn_entity")



local buy = {}




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



function buy.buyCard(card_ent, cost)
    local board = Board.getBoard(card_ent.rgbTeam)
    cost = cost or buy.getCost(card_ent)

    local etype = card_ent.cardBuyTarget
    if etype.cardInfo.type == constants.CARD_TYPES.UNIT then
        buyUnitCard(card_ent)
    else 
        -- TODO: Spell cards, and other stuff
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


server.on("sellSquadron", function(sender, ent)
    if not umg.exists(ent) then
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

