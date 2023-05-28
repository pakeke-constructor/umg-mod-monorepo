
local Board
if server then
    Board = require("server.board")
end


return {
    image = "2_of_clubs_card",

    cardInfo = {
        type = constants.CARD_TYPES.SPELL,
        cost = 3,
        name = "2 of clubs",
        description = "Adds [color] to all shop cards",
        difficultyLevel = 0,

        spellCast = function(self)
            local board = Board.getBoard(self.rgbTeam)
            board:getShopCards():map(function(cardEnt)
                local newRGB = rgb.add(cardEnt.rgb, self.rgb)
                rgbAPI.changeRGB(cardEnt, newRGB)
            end)
        end
    },
}
