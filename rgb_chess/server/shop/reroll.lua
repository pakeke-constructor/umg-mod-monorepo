
local Board = require("server.board")

local genCards = require("server.gen.generate_cards")


local reroll = {}


function reroll.rerollCard(rgbTeam, card)
    local board = Board.getBoard(rgbTeam)
    local shopIndex = card.shopIndex
    if not card.isLocked then
        -- then we reroll
        if umg.exists(card) then
            umg.call("rerollCard", card)
            card:delete()
        end
        base.delay(constants.REROLL_TIME, function()
            genCards.spawnCard(board, shopIndex)
        end)
    end
end




function reroll.rerollAllCards(rgbTeam)
    local board = Board.getBoard(rgbTeam)
    local rgb_team = board:getOwner()
    local squadronCount = rgb.getSquadronCount(rgbTeam)

    for i=1, board.shopSize do
        local delay = (i/board.shopSize) * 0.3
        base.delay(delay, function()
            reroll.rerollCard(rgbTeam, squadronCount) 
        end)
    end

    umg.call("reroll", rgb_team)
end


return reroll

