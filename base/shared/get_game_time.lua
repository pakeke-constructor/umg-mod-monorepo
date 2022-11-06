


local currentGameTime = timer.getTime()


on("gameUpdate", function(dt)
    currentGameTime = currentGameTime + dt
end)




local function getGameTime()
    -- this function should be a drop-in-replacement for
    -- timer.getTime(); where it returns the game update time.
    return currentGameTime
end

return getGameTime

