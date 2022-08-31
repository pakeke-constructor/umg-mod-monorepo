
local Board = require("server.board")

local genCards = require("server.gen.generate_cards")



local function rerollSingle(rgbTeam, shopIndex)
    local board = Board.getBoard(rgbTeam)
    local card = board.shop[shopIndex]
    local isLocked = board.shopLocks[shopIndex]
    if not isLocked then
        -- then we reroll
        if exists(card) then
            server.broadcast("rerollCard", card)
            card:delete()
        end
        genCards.spawnCard(board, shopIndex)
    end
end




local function reroll(rgbTeam)
    local board = Board.getBoard(rgbTeam)
    local rgb_team = board:getOwner()

    for i=1, board.shopSize do
        rerollSingle(rgbTeam, i)
    end

    call("reroll", rgb_team)
end



return {
    reroll = reroll,
    rerollSingle = rerollSingle
}


