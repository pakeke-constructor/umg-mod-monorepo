

local options = require("shared.options")

local getSpeed = require("shared.speed")




-- TODO: Play around with this number!
local NUMBER_SYNC_THRESHOLD = 0.5
--[[
TODO: This number should also be configurable.
When mod launch options are supported, this should be a configurable value.
]]




local abs = math.abs



sync.autoSyncComponent("x", {
    lerp = true,
    numberSyncThreshold = NUMBER_SYNC_THRESHOLD,
    
    controllable = {
        shouldAcceptServerside = function(ent, x)
            local max_delta = getSpeed(ent) * options.SYNC_LEIGHWAY
            return abs(ent.x - x) <= max_delta
        end
    }
})


sync.autoSyncComponent("x", {

})




