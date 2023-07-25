
--[[
automatic syncing for entity look directions

lookX and lookY

]]

local LOOK_SYNC_THRESHOLD = 0.1




sync.autoSyncComponent("lookX", {
    lerp = true,
    numberSyncThreshold = LOOK_SYNC_THRESHOLD,
    
    bidirectional = {
        shouldAcceptServerside = function(ent, lookX)
            -- Only accept packets that
            return type(lookX) == "number" 
        end,

        shouldForceSyncClientside = function(ent, lookX)
            -- always take the client's look position as the correct one
            return false
        end
    }
})


sync.autoSyncComponent("lookY", {
    lerp = true,
    numberSyncThreshold = LOOK_SYNC_THRESHOLD,
    
    bidirectional = {
        shouldAcceptServerside = function(ent, lookY)
            return type(lookY) == "number" 
        end,

        shouldForceSyncClientside = function(ent, lookY)
            -- always take the client's look position as the correct one
            return false
        end
    }
})


