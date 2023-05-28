
local Board
if server then
    Board = require("server.board")
end


return {
    image = "10_of_clubs_card",

    cardInfo = {
        type = constants.CARD_TYPES.SPELL,
        cost = 3,
        name = "10 of clubs",
        description = "Rerolls all non-[color] shop cards",
        difficultyLevel = 1,

        spellCast = function(self)
            local board = Board.getBoard(self.rgbTeam)
            for i=1, board.shopSize do
                local card = board:getCard(i)
                if umg.exists(card) and self ~= card then
                    if not rgb.match(card.rgb, self.rgb) then
                        board:rerollCard(i)
                    end
                end
            end
        end
    },
}

