
local Board = require("server.board")


local readyUpButtonEnts = group("readyUpButton")


local AUTO_START_TIME = math.huge -- battle will auto start after X seconds.


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
    for _, ent in ipairs(readyUpButtonEnts) do
        server.broadcast("rgbReadyButton_setReadyFalse", ent)
        ent.rgb_is_ready = false
    end
    usernameToIsReady = {}
end


function readyUp.shouldStartBattle()
    local time = timer.getTime()
    if time > turnStartTime + AUTO_START_TIME then
        return true
    end

    local itered = false
    for username, _ in Board.iterBoards() do
        itered = true
        if not usernameToIsReady[username] then
            return false
        end
    end

    return itered
end




return readyUp

