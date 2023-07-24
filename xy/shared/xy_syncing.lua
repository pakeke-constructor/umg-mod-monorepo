

local options = require("shared.options")
local constants = require("shared.constants")

local getSpeed = require("shared.get_speed")


local NUMBER_SYNC_THRESHOLD = constants.NUMBER_SYNC_THRESHOLD




local abs = math.abs




local getTickDelta = sync.getTickDelta

sync.autoSyncComponent("x", {
    lerp = true,
    numberSyncThreshold = NUMBER_SYNC_THRESHOLD,
    
    --[[
    TODO:
    There's a big(ish) issue with this verification.
    Currently, we simply check that the distance is not too big.
    But... this doesn't account for the fact that the entity will
    have already been moved on the server.

    (assuming SYNC_LEIGHWAY == 1.5,) hacked clients can go 50%.
    But, smart hacked clients will be able to go 150% faster.

    This is because the server treats each entity position as the last
    position that it's seen from the client; when in reality,
    it's not.

    To explain, with speed = 1.
    client --> server:  set X = 1
    server: moves entity += 1
    client --> server:  set X = 3.5 (2.5 times as fast!)
    ^^^ server accepts packet, because it's treating the current entity
        position as the last entity position sent.

    Possible workaround for this:
        who cares!! :-)
    ]]
    bidirectional = {
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
    
    bidirectional = {
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



