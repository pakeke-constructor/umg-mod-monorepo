
local Board
if server then
    Board = require("server.board")
end


return {
    image = "0_of_clubs_card",

    cardInfo = {
        type = constants.CARD_TYPES.SPELL,
        cost = 3,
        name = "0 of clubs",
        description = "Removes [color] from all shop cards",

        spellCast = function(self)
            local board = Board.getBoard(self.rgbTeam)
            board:getShopCards():map(function(cardEnt)
                local newRGB = rgb.subtract(cardEnt.rgb, self.rgb)
                rgbAPI.changeRGB(cardEnt, newRGB)
            end)
        end
    },
}
