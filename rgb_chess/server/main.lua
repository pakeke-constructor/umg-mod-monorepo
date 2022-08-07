

local clientToBoardPos = {
--[[
    [client] = {x, y} -- board position
]]
}

local currentClientBoardPos = 0


on("join", function(uname)
    -- Allocate board space.
    clientToBoardPos[uname] = {0, currentClientBoardPos}
    currentClientBoardPos = currentClientBoardPos + 1000
end)





