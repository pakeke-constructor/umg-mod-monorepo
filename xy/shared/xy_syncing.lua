

local options = require("shared.options")

local getSpeed = require("shared.speed")




--  need to differ by more than 0.5 before a sync is enacted.
-- TODO: Play around with this number!
local XY_SYNC_THRESHOLD = 0.5
--[[
TODO: This number should also be configurable.
When mod launch options are supported, this should be a configurable value.
]]




local abs = math.abs


local getTickDelta = sync.getTickDelta

sync.autoSyncComponent("x", {
    lerp = true,
    numberSyncThreshold = XY_SYNC_THRESHOLD,
    
    controllable = {
        shouldAcceptServerside = function(ent, x)
            -- Only accept packets that
            local dt = getTickDelta()
            local max_delta = getSpeed(ent) * options.SYNC_LEIGHWAY * dt
            return abs(ent.x - x) <= max_delta
        end,

        shouldForceSyncClientside = function(ent, x)
            local dt = getTickDelta()
            local max_delta = getSpeed(ent) * options.SYNC_LEIGHWAY * dt
            -- If the actual delta is greater than expected, force a sync.
            return abs(ent.x - x) > max_delta
        end
    }
})



sync.autoSyncComponent("y", {
    lerp = true,
    numberSyncThreshold = XY_SYNC_THRESHOLD,
    
    controllable = {
        shouldAcceptServerside = function(ent, y)
            -- Only accept packets that
            local dt = getTickDelta()
            local max_delta = getSpeed(ent) * options.SYNC_LEIGHWAY * dt
            return abs(ent.y - y) <= max_delta
        end,

        shouldForceSyncClientside = function(ent, y)
            local dt = getTickDelta()
            local max_delta = getSpeed(ent) * options.SYNC_LEIGHWAY * dt
            -- If the actual delta is greater than expected, force a sync.
            return abs(ent.y - y) > max_delta
        end
    }
})



sync.autoSyncComponent("y", {
    lerp = true,
    numberSyncThreshold = XY_SYNC_THRESHOLD,
})




