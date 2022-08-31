
local Board = require("server.board")

local genCards = require("server.gen.generate_cards")





local function reroll(rgbTeam)
    local board = Board.getBoard(rgbTeam)
    local rgb_team = board:getOwner()

    for i=1, board.shopSize do
        local card = board.shop[i]
        local isLocked = board.shopLocks[i]
        if not isLocked then
            -- then we reroll
            if exists(card) then
                server.broadcast("rerollCard", card)
                card:delete()
            end
            genCards.spawnCard(board, i)
        end
    end
    call("reroll", rgb_team)
end


return {
    reroll = reroll
}


