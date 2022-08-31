
require("shared.globals")

local Board = require("server.board")

local generateEnemies = require("server.gen.generate_pve")
local generateBoardDecor = require("server.gen.generate_board_decor")

local readyUp = require("server.ready_up")

local START_MONEY = 10



local currentClientBoardPos = 0


local function allocateBoard(username)
    -- Allocate board space:
    local board = Board(0, currentClientBoardPos, username)
    currentClientBoardPos = currentClientBoardPos + 1000
    generateBoardDecor(board)
    board:setMoney(START_MONEY)

    local rbx,rby = board:getRerollButtonXY()
    local butto = entities.reroll_button(rbx, rby)
    butto.rgbTeam = username
end


on("playerJoin", function(username)
    local plyr_ent = entities.player(0, 0)
    plyr_ent.controller = username
end)



on("playerLeave", function(username)
    base.getPlayer(username):delete()
    local b = Board.getBoard(username)
    if b then
        b:delete()
    end
end)




local function saveBoards()
    for _, board in Board.iterBoards() do
        board:serialize()
    end
end





local states = {
    LOBBY_STATE = 1,
    BATTLE_STATE = 2,
    TURN_STATE = 3
}

local state = states.LOBBY_STATE



local function startBattle()
    call("endTurn")
    call("startBattle")
    state = states.BATTLE_STATE
    saveBoards()
end


local function startPvE()
    startBattle()
    for _, board in Board.iterBoards() do
        generateEnemies(board.turn)
    end
end


local function startPvP()
    startBattle()
end




local function startTurn()
    call("endBattle")
    call("startTurn")
    state = states.TURN_STATE
    for _, board in Board.iterBoards() do
        board:clear()
        board:reset()
    end
end


local function startGame()
    assert(state == states.LOBBY_STATE)
    for _,player in ipairs(server.getPlayers()) do
        allocateBoard(player)
    end
end





local function updateTurn()
    if readyUp.shouldStartBattle() then
        startPvE()
        readyUp.resetReady()
    end
end


local function updateBattle()

end

local function updateLobby()
    
end


local updates = {
    [states.LOBBY_STATE] = updateLobby,
    [states.BATTLE_STATE] = updateBattle,
    [states.TURN_STATE] = updateTurn
}

on("update", function(dt)
    updates[state](dt)
end)



chat.handleCommand("start", function(sender)
    startGame()
end)


