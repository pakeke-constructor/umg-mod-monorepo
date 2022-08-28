

--[[

Generates cards for shop rerolls.

USAGE:
]]


local tiers = {
    [1] = {
        "card_brute"
    },

    [2] = {

    }, 

    [3] = {

    },

    [4] = {

    }
}




local genCards = {}


function genCards.getCard(board)
    local turn = board:getTurn()
    return "card_brute" -- TODO: Write this function
end




