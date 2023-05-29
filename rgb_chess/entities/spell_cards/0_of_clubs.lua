
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
        image = "0_of_clubs_card",
        description = "Removes [color] from all shop cards",
        difficultyLevel = 0,

        spellCast = function(card)
            local board = Board.getBoard(card.rgbTeam)
            local rgbCol = card.rgb
            board:getShopCards():map(function(cardEnt)
                local newRGB = rgb.subtract(cardEnt.rgb, rgbCol)
                rgbAPI.changeRGB(cardEnt, newRGB)
            end)
        end
    },
}
