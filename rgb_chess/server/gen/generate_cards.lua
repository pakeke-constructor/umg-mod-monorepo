

--[[

Generates cards for shop rerolls.

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



function genCards.getXY(board, i)
    -- TODO: get the (x,y) position of cards from a given index i
end



local function copyColor(col)
    local cpy = {}
    for i=1, 3 do
        cpy[i] = col[i]
    end
    return cpy
end



function genCards.getRGB(turn)
    return rgb.RED -- TODO: Do something proper for this
end


function genCards.spawnCard(board, i)
    local turn = board:getTurn()
    local etype = genCards.getCard(board)
    local x, y = genCards.getXY(board, i)
    local ent = entities[etype](x, y)
    ent.rgbTeam = board:getTeam()
    ent.rgb = genCards.getRGB(turn)
    ent.color = copyColor(ent.rgb)
end


