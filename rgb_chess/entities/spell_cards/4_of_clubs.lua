
local Board
if server then
    Board = require("server.board")
end


return {
    image = "4_of_clubs_card",

    cardInfo = {
        type = constants.CARD_TYPES.SPELL,
        cost = 3,
        name = "4 of clubs",
        description = "Set all shop cards to [color]",
        difficultyLevel = 0,

        spellCast = function(self)
            local board = Board.getBoard(self.rgbTeam)
            board:getShopCards():map(function(cardEnt)
                rgbAPI.changeRGB(cardEnt, self.rgb)
            end)
        end
    },
}
