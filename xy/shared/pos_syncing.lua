

local options = require("shared.options")
local constants = require("shared.constants")

local getSpeed = require("shared.speed")


local NUMBER_SYNC_THRESHOLD = constants.NUMBER_SYNC_THRESHOLD




local abs = math.abs


local getTickDelta = sync.getTickDelta

sync.autoSyncComponent("x", {
    lerp = true,
    numberSyncThreshold = NUMBER_SYNC_THRESHOLD,
    
    controllable = {
        shouldAcceptServerside = function(ent, x)
            -- Only accept positions of players that aren't moving TOO fast.
            local dt = getTickDelta()
            local max_delta = getSpeed(ent) * options.SYNC_LEIGHWAY * dt
            return abs(ent.x - x) <= max_delta
        end,

        shouldForceSyncClientside = function(ent, x)
            -- Only accept positions of players that aren't moving TOO fast.
            local dt = getTickDelta()
            local max_delta = getSpeed(ent) * options.SYNC_LEIGHWAY * dt
            -- If the actual delta is greater than expected, force a sync.
            return abs(ent.x - x) > max_delta
        end
    }
})



sync.autoSyncComponent("y", {
    lerp = true,
    numberSyncThreshold = NUMBER_SYNC_THRESHOLD,
    
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





