
--[[

Schedules a function to be ran every X events, instead of every event.
Useful for running code every 5 frames, for example.

]]

local runEveryTc = typecheck.assert("number", "string", "function")


local function runEvery(skips, event, func)
    --[[
        listens to a callback, but only runs it every `skips` runs.
    ]]
    runEveryTc(skips, event, func)

    local currentSkip = 0

    umg.on(event, function(...)
        currentSkip = currentSkip + 1

        if currentSkip >= skips then
            func(...)
            currentSkip = 0
        end
    end)
end


return runEvery
