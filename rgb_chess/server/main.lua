
require("shared.globals")

local Board = require("server.board")



local clientToBoard = {
--[[
    [client] = Board
]]
}

local currentClientBoardPos = 0


on("playerJoin", function(uname)
    -- Allocate board space:
    local board = Board(0, currentClientBoardPos, uname)
    clientToBoard[uname] = board

    local plyr_ent = entities.player(0, currentClientBoardPos)
    plyr_ent.controller = uname
    print("plauer created?")

    entities.card_brute1(10, currentClientBoardPos)

    currentClientBoardPos = currentClientBoardPos + 1000
end)



local clientToBoardSave = {
--[[
    [client] = Board_save_data
]]
}

on("saveBoards", function()
    for player, board in pairs(clientToBoard) do
        -- TODO
    end
end)



