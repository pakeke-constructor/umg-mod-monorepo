

local sync = {}


sync.denoteEventProxy = require("shared.proxy")

sync.autoSyncComponent = require("shared.auto_sync_component")


umg.expose("sync", sync)
