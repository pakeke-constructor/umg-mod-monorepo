

local sync = {}


sync.proxyEventToClient = require("shared.proxy")

sync.autoSyncComponent = require("shared.auto_sync_component")

local filterAPI = require("shared.filters")
sync.filters = filterAPI.filters
sync.defineFilter = filterAPI.defineFilter


local tickDelta = require("shared.tick_delta")
sync.getTickDelta = tickDelta.getTickDelta
sync.getTimeOfLastTick = tickDelta.getTimeOfLastTick



if server then
    -- only available serverside.
    sync.syncComponent = require("shared.manual_sync_component")
end




umg.expose("sync", sync)
