
local Board = require("server.board")



local AUTO_START_TIME = 60 -- max 60 seconds for turn time.


local usernameToIsReady = {
-- [username] = true/false
-- whether the user is ready for next round or not
}





local readyUp = {}



function readyUp.readyUp(username)
    usernameToIsReady[username] = true
end


function readyUp.readyUpCancel(username)
    usernameToIsReady[username] = false
end


function readyUp.isReady(username)
    return usernameToIsReady[username]
end



local turnStartTime = timer.getTime()

on("startTurn", function()
    turnStartTime = timer.getTime()
end)



function readyUp.resetReady()
    usernameToIsReady = {}
end


function readyUp.shouldStartBattle()
    local time = timer.getTime()
    if time + AUTO_START_TIME > turnStartTime then
        return true
    end

    for username, _ in Board.iterBoards() do
        if not usernameToIsReady[username] then
            return false
        end
    end

    return true
end




return readyUp

