
require("shared.globals")

local Board = require("server.board")



local clientToBoard = {
--[[
    [client] = Board
]]
}

local currentClientBoardPos = 0


on("join", function(uname)
    -- Allocate board space:
    local board = Board(0, currentClientBoardPos, uname)
    clientToBoard[uname] = board
    currentClientBoardPos = currentClientBoardPos + 1000
end)





