

local scheduleTc = typecheck.assert("number", "string", "function")

--[[
    TODO: 
    Rename this function to something a bit more meaningful.

    Ideas:
    runAfter(6, "update", func)
    
]]
local function skippedOn(skips, event, func)
    scheduleTc(skips, event, func)

    local currentSkip = 0

    umg.on(event, function(...)
        currentSkip = currentSkip + 1

        if currentSkip >= skips then
            func(...)
            currentSkip = 0
        end
    end)
end


return skippedOn
