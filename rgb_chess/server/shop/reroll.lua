
local Board = require("server.board")

local genCards = require("server.gen.generate_cards")


local reroll = {}


function reroll.rerollSlot(rgbTeam, shopIndex)
    local board = Board.getBoard(rgbTeam)
    local card = board:getCard(shopIndex)
    if umg.exists(card) and card.isLocked then
        return
    end

    -- we good to reroll
    if umg.exists(card) then
        umg.call("rerollCard", card)
        card:delete()
    end

    base.delay(constants.REROLL_TIME, function()
        genCards.spawnCard(board, shopIndex)
    end)
end




function reroll.rerollAllCards(rgbTeam)
    local board = Board.getBoard(rgbTeam)
    local rgb_team = board:getOwner()

    for shopIndex=1, board.shopSize do
        local delay = (shopIndex/board.shopSize) * 0.3
        base.delay(delay, function()
            reroll.rerollSlot(rgbTeam, shopIndex)
        end)
    end

    umg.call("reroll", rgb_team)
end


return reroll

