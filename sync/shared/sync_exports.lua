

local sync = {}


sync.denoteEventProxy = require("shared.proxy")

sync.autoSyncComponent = require("shared.auto_sync_component")

local filterAPI = require("shared.filters")
sync.filters = filterAPI.filters
sync.defineFilter = filterAPI.defineFilter


umg.expose("sync", sync)
