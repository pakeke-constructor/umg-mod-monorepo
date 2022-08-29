
local Board = require("server.board")

local genCards = require("server.gen.generate_cards")




local breakFrames = {}
for i=1,7 do
    table.insert(breakFrames, "unit_card_rip" .. tostring(i))
end



local function reroll(rgbTeam)
    local board = Board.getBoard(rgbTeam)
    for i, card in ipairs(board.shop) do
        local isLocked = board.shopLocks[i]
        if not isLocked then
            -- then we reroll
            if exists(card) then
                -- TODO:
                -- im an idiot.
                -- this needs to be broadcasted to the client.
                base.animate(breakFrames, 0.3, card.x, card.y, card.z, card.color)
                card:delete()
            end
            local newCard = genCards.getCard(board)
            board.shop[i] = newCard
        end
    end
    local username = board:getOwner()
    call("reroll", username)
end


return {
    reroll = reroll
}


