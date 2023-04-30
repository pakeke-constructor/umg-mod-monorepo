

local sync = {}


sync.defineEventProxy = require("shared.proxy")

sync.autoSyncComponent = require("shared.auto_sync_component")


umg.expose("sync", sync)
