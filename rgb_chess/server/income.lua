
local Board = require("server.board")



local income = {}


function income.getIncome(board)
    local inc = 0
    inc = inc + rgb.getTurn()
    if board:isWinner() then
        inc = inc + constants.WIN_INCOME
    else
        inc = inc + constants.LOSE_INCOME
    end
    return math.min(inc, constants.MAX_INCOME)
end


function income.doAllIncome()
    for _, board in Board.iterBoards()do
        board:setMoney(board:getMoney() + income.getIncome(board))
    end
end


function income.syncMoney()
    for _, board in Board.iterBoards() do
        -- this will just sync the player money counts.
        board:setMoney(board:getMoney())
    end
end



return income

