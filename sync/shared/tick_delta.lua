

local lastTickDelta = 0.1 -- this value is pretty arbitrary and does matter
local timeOfLastTick = love.timer.getTime()

local MIN_TICK_DELTA = 0.01

local max = math.max

umg.on("@tick", function()
    local time = love.timer.getTime()
    lastTickDelta = max(MIN_TICK_DELTA, time - timeOfLastTick)
    timeOfLastTick = time
end)



local tickDelta = {}

function tickDelta.getTickDelta()
    -- gets the time between two ticks
    return lastTickDelta
end

function tickDelta.getTimeOfLastTick()
    return timeOfLastTick
end


return tickDelta
