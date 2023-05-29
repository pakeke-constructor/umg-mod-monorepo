
local Board
if server then
    Board = require("server.board")
end


return {

    cardInfo = {
        type = constants.CARD_TYPES.SPELL,
        cost = 3,
        name = "4 of clubs",
        image = "4_of_clubs_card",
        description = "Adds [color] to all shop cards",
        difficultyLevel = 0,

        spellCast = function(card)
            local board = Board.getBoard(card.rgbTeam)
            board:getShopCards():map(function(cardEnt)
                local newRGB = rgb.add(cardEnt.rgb, card.rgb)
                rgbAPI.changeRGB(cardEnt, newRGB)
            end)
        end
    },
}
