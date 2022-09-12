
require("shared.rgb")

local Board = require("server.board")

local matchmaking = require("server.matchmaking")

local generatePVE = require("server.gen.generate_pve")
local generateBoardDecor = require("server.gen.generate_board_decor")

local readyUp = require("server.ready_up")

local START_MONEY = 10


local turn = 1

local currentClientBoardPos = 0


local function allocateBoard(username)
    -- Allocate board space:
    local board = Board(0, currentClientBoardPos, username)
    currentClientBoardPos = currentClientBoardPos + 1000
    generateBoardDecor(board)
    board:setMoney(START_MONEY)

    local rbx,rby = board:getRerollButtonXY()
    entities.reroll_button(rbx, rby, username)

    local monx, mony = board:getMoneyTextXY()
    entities.money_text(monx, mony, username)

    local bbx,bby = board:getBattleButtonXY()
    entities.readyup_button(bbx, bby, username)
end



on("playerJoin", function(username)
    local plyr_ent = entities.player(0, 0)
    plyr_ent.controller = username
    
    rgb.setState(rgb.getState()) -- this doesnt change the state,
    -- we just need to update the new player.
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





rgb.setState(rgb.STATES.LOBBY_STATE)



local battleStartTime = timer.getTime()

local function setupBattle()
    battleStartTime = timer.getTime()
    call("endTurn")
    call("startBattle")
    rgb.setState(rgb.STATES.BATTLE_STATE)
    saveBoards()
end




local function finalizePvE(board, enemies)
    board:putEnemies(enemies)
    local allyArray = {}
    for _,ent in rgb.ipairs(board:getTeam()) do 
        table.insert(allyArray, ent)
    end
    board:putAllies(allyArray)
end


local function startPvE()
    setupBattle()
    for _, board in Board.iterBoards() do
        local enemyTeam = rgb.getPVEEnemyTeam(board:getTeam())
        board:setEnemyTeam(enemyTeam)
        local enemies = generatePVE.generateEnemies(board.turn)
        base.delay(1, finalizePvE, board, enemies)
    end
end




local function setupPvPMatch(match)
    -- TODO: Lock camera positions to this board.
    local board = Board.getBoard(match.home)

    -- TODO: Maybe delay this for cool effect?
    board:setEnemyTeam(match.away)
    local allyArray = {}
    for _,ent in rgb.ipairs(match.home) do 
        table.insert(allyArray, ent)
    end
    local enemyArray = {}
    for _,ent in rgb.ipairs(match.away) do 
        table.insert(enemyArray, ent)
    end
    board:putAllies(allyArray)
    board:putEnemies(enemyArray)
end


local function startPvP()
    setupBattle()
    local matches = matchmaking.makeMatches()
    for _, match in ipairs(matches)do
        if not match.bye then
            setupPvPMatch(match)
        else
            -- Do something for byes..?
        end
    end
end



local inTurnTransition = false


local function startTurn()
    inTurnTransition = false
    call("endBattle")
    call("startTurn")
    rgb.setState(rgb.STATES.TURN_STATE)
    for _, board in Board.iterBoards() do
        board:clear()
        board:reset()
    end
end


local function startGame()
    assert(rgb.state == rgb.STATES.LOBBY_STATE)
    for _,player in ipairs(server.getPlayers()) do
        allocateBoard(player)
    end
    rgb.setState(rgb.STATES.TURN_STATE)
    matchmaking.startGame()
end



local function updateTurn()
    if (not inTurnTransition) and readyUp.shouldStartBattle() then
        inTurnTransition = true
        for i=1, 10 do
            base.delay(10 - i, function(x)
                chat.message("(SERVER) - starting battle in " .. tostring(x) .. " seconds.")
            end, i)
        end

        base.delay(10, function()
            -- transition to battle state:
            if matchmaking.isPVE(turn) then
                chat.message("(SERVER) - starting PvE battle!")
                startPvE()
            else
                chat.message("(SERVER) - starting Player PvP battle!")
                startPvP()
            end
            readyUp.resetReady()
            turn = turn + 1
        end)
    end
end


local MINIMUM_BATTLE_DURATION = 5

local function updateBattle()
    -- check if all boards are done battle.
    -- If so, start turn.
    local time = timer.getTime()

    local isBattleOver = true and (time > battleStartTime + MINIMUM_BATTLE_DURATION)
    for _, board in Board.iterBoards()do
        if not board:isBattleOver() then
            isBattleOver = false
        end
    end

    if isBattleOver then
        -- battle is over! Transition to `turn` state.
        chat.message("(SERVER) - battle round has completed.")
        startTurn()
    end
end


local function updateLobby()
    
end



local updates = {
    [rgb.STATES.LOBBY_STATE] = updateLobby,
    [rgb.STATES.BATTLE_STATE] = updateBattle,
    [rgb.STATES.TURN_STATE] = updateTurn
}

on("update", function(dt)
    updates[rgb.state](dt)
end)



chat.handleCommand("start", function(sender)
    startGame()
end)


