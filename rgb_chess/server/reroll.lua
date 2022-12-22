
local Board = require("server.board")

local buy = require("server.buy")
local genCards = require("server.gen.generate_cards")



local function rerollSingle(rgbTeam, shopIndex, numSquadrons)
    local board = Board.getBoard(rgbTeam)
    local card = board.shop[shopIndex]
    local isLocked = board.shopLocks[shopIndex]
    if not isLocked then
        -- then we reroll
        if umg.exists(card) then
            server.broadcast("rerollCard", card)
            card:delete()
        end
        base.delay(constants.REROLL_TIME, function()
            local card_ent = genCards.spawnCard(board, shopIndex)
            card_ent.cost = buy.getCost(card_ent, numSquadrons)
        end)
    end
end




local function reroll(rgbTeam)
    local board = Board.getBoard(rgbTeam)
    local rgb_team = board:getOwner()
    local squadronCount = rgb.getSquadronCount(rgbTeam)

    for i=1, board.shopSize do
        local delay = (i/board.shopSize) * 0.3
        base.delay(delay, function() rerollSingle(rgbTeam, i, squadronCount) end)
    end

    umg.call("reroll", rgb_team)
end



return {
    reroll = reroll,
    rerollSingle = rerollSingle
}


