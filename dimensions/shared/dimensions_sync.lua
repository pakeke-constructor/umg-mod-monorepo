
require("dimensions_events")



sync.autoSyncComponent("dimension", {
    syncWhenNil = true
})



sync.proxyEventToClient("dimensions:entityMoved")
sync.proxyEventToClient("dimensions:dimensionCreated")
sync.proxyEventToClient("dimensions:dimensionDestroyed")


