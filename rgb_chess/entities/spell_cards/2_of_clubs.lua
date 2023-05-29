
local Board
if server then
    Board = require("server.board")
end


return {
    cardInfo = {
        type = constants.CARD_TYPES.SPELL,
        cost = 3,
        name = "2 of clubs",
        image = "2_of_clubs_card",
        description = "Set all shop cards to [color]",
        difficultyLevel = 0,

        spellCast = function(card)
            local board = Board.getBoard(card.rgbTeam)
            board:getShopCards():map(function(cardEnt)
                rgbAPI.changeRGB(cardEnt, card.rgb)
            end)
        end
    },
}
