
require("shared.rgb")

local Board = require("server.board")

local matchmaking = require("server.battle.matchmaking")

local abilities = require("shared.abilities.abilities")

local income = require("server.shop.income")

local generatePVE = require("server.gen.generate_pve")
local generateBoardDecor = require("server.gen.generate_board_decor")

local readyUp = require("server.shop.ready_up")

local START_MONEY = 10




local currentClientBoardPos = 0


local function allocateBoard(username)
    -- Allocate board space:
    local board = Board(currentClientBoardPos, 0, username)
    currentClientBoardPos = currentClientBoardPos + 1000
    generateBoardDecor(board)
    board:setMoney(START_MONEY)

    board:spawnObjects()

    board:emplacePlayer(username)
end



umg.on("@playerJoin", function(username)
    local plyr_ent = server.entities.player(0, 0)
    plyr_ent.controller = username
    plyr_ent.rgbTeam = username

    rgb.setState(rgb.getState()) -- this doesnt change the state,
    -- we just need to update the new player.
end)



umg.on("@playerLeave", function(username)
    local player = control.getPlayer(username)
    if player then
        control.getPlayer(username):delete()
        local b = Board.getBoard(username)
        if b then
            b:delete()
        end
    end
end)




local function saveBoards()
    for _, board in Board.iterBoards() do
        board:serialize()
    end
end





rgb.setState(rgb.STATES.LOBBY_STATE)






local function finalizePvE(board, enemies)
    board:putEnemies(enemies)
    local allyArray = {}
    for _, ent in ipairs(board:getUnits()) do 
        table.insert(allyArray, ent)
    end
    board:putAllies(allyArray)
end


local function startPvE()
    for _, board in Board.iterBoards() do
        local enemyTeam = rgb.getPVEEnemyTeamName(board:getTeam())
        board:setEnemyTeam(enemyTeam)
        local enemies = generatePVE.generateEnemies(rgb.getTurn())
        scheduling.delay(1, finalizePvE, board, enemies)
    end
end




local function setupPvPMatch(match)
    local board = Board.getBoard(match.home)
    local awayBoard = Board.getBoard(match.away)
    board:emplacePlayer(match.home)
    board:emplacePlayer(match.away)

    server.unicast(match.home, "setupPvPMatch", match.away)
    server.unicast(match.away, "setupPvPMatch", match.home)

    -- TODO: Maybe delay this for cool effect?
    board:setEnemyTeam(match.away)
    local allyArray = {}
    for _, ent in ipairs(board:getUnits()) do 
        table.insert(allyArray, ent)
    end
    local enemyArray = {}
    for _, ent in ipairs(awayBoard:getUnits()) do 
        table.insert(enemyArray, ent)
    end
    board:putAllies(allyArray)
    board:putEnemies(enemyArray)
end


local function startPvP()
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

local inBattleTransition = false


local function startTurn()
    inTurnTransition = false
    abilities.reset()
    rgb.setState(rgb.STATES.TURN_STATE)
    for _, board in Board.iterBoards() do
        board:emplacePlayer(board:getTeam())
        board:clear()
        board:reset()
    end
    income.doAllIncome()

    -- we gotta delay here, as we gotta wait a tick for the entities to spawn
    scheduling.nextTick(function()
        abilities.reset()
        abilities.triggerForAll("startTurn")
        umg.call("startTurn")
    end)
end


local function startGame()
    assert(rgb.state == rgb.STATES.LOBBY_STATE, "?")
    for _,player in ipairs(server.getPlayers()) do
        allocateBoard(player)
    end
    rgb.setState(rgb.STATES.TURN_STATE)
    matchmaking.startGame()
end



local battleStartTime = love.timer.getTime()

local function startBattle()
    inBattleTransition = false
    battleStartTime = love.timer.getTime()

    rgb.setState(rgb.STATES.BATTLE_STATE)
    saveBoards()

    abilities.reset()
    abilities.triggerForAll("startBattle")
    umg.call("startBattle")

    if matchmaking.isPVE(rgb.getTurn()) then
        chat.message("(SERVER) - starting PvE battle!")
        startPvE()
    else
        chat.message("(SERVER) - starting Player PvP battle!")
        startPvP()
    end
    readyUp.resetReady()
    rgb.increaseTurnCount()
end


local function endBattle()
    umg.call("endBattle")
    abilities.triggerForAll("endBattle")
end


local function endTurn()
    inTurnTransition = true
    abilities.triggerForAll("endTurn")
    umg.call("endTurn")

    -- do a countdown in chat:
    local DELAY = constants.END_TURN_DELAY 
    for i=1, DELAY do
        scheduling.delay(DELAY - i, function(x)
            chat.message("(SERVER) - starting battle in " .. tostring(x) .. " seconds.")
        end, i)
    end

    -- start battle after X seconds:
    scheduling.delay(DELAY, startBattle)
end



local function updateTurn()
    if (not inTurnTransition) and readyUp.shouldStartBattle() then
        endTurn()
    end
end


local MINIMUM_BATTLE_DURATION = constants.MINIMUM_BATTLE_DURATION

local function updateBattle()
    -- check if all boards are done battle.
    -- If so, start turn.
    local time = love.timer.getTime()

    local isBattleOver = true and (time > battleStartTime + MINIMUM_BATTLE_DURATION)
    for _, board in Board.iterBoards()do
        if not board:isBattleOver() then
            isBattleOver = false
        end
    end

    if isBattleOver and (not inBattleTransition) then
        -- battle is over! Transition to `turn` state.
        inBattleTransition = true
        chat.message("(SERVER) - battle round has completed.")
        endBattle()

        scheduling.delay(constants.END_BATTLE_DELAY, startTurn)
    end
end


local function updateLobby()
    
end



local updates = {
    [rgb.STATES.LOBBY_STATE] = updateLobby,
    [rgb.STATES.BATTLE_STATE] = updateBattle,
    [rgb.STATES.TURN_STATE] = updateTurn
}

umg.on("state:gameUpdate", function(dt)
    updates[rgb.state](dt)
end)



chat.handleCommand("start", {
    adminLevel = 1,
    arguments = {},

    handler = function(sender)
        startGame()
    end
})

chat.handleCommand("setMoney", {
    adminLevel = 10,
    arguments = {{name = "money", type = "number"}},

    handler = function(sender, money)
        local board = Board.getBoard(sender)
        if board then
            local num = tonumber(money,10)
            if num then board:setMoney(num) end
        end
    end
})

