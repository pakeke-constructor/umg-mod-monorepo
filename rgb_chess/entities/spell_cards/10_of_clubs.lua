
local Board
if server then
    Board = require("server.board")
end


return {
    cardInfo = {
        type = constants.CARD_TYPES.SPELL,
        cost = 3,
        name = "10 of clubs",
        image = "10_of_clubs_card",
        description = "Rerolls all non-[color] shop cards",
        difficultyLevel = 1,

        spellCast = function(card)
            local board = Board.getBoard(card.rgbTeam)
            for i=1, board.shopSize do
                local crd = board:getCard(i)
                if umg.exists(crd) and crd ~= card then
                    if not rgb.match(crd.rgb, card.rgb) then
                        board:rerollCard(i)
                    end
                end
            end
        end
    },
}

