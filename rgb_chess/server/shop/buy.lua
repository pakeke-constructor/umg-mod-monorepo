
local Board = require("server.board")

local spawnEntity = require("server.shop.spawn_entity")



local buy = {}




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
    if rgb.isUnitCard(card_ent) then
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



function buy.canBuy(card_ent)
    if rgb.state ~= rgb.STATES.TURN_STATE then
        return false
    end

    local cost = buy.getCost(card_ent)
    local board = Board.getBoard(card_ent.rgbTeam)
    return cost <= board:getMoney() 
end




local function sellUnit(ent)
    umg.call("sellUnit", ent)
    ent:delete()
end


function buy.sellSquadron(ent)
    umg.call("sellSquadron", ent.squadron)
    local baseCost = ent.unitCardInfo.cost
    assert(ent.squadron,"?")
    local board = Board.getBoard(ent.rgbTeam)
    board:setMoney(board:getMoney() - baseCost)
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

