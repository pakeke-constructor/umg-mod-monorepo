
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
    return inc
end


function income.doAllIncome()
    for _, board in Board.iterBoards()do
        board:setMoney(board:getMoney() + income.getIncome(board))
    end
end



return income
