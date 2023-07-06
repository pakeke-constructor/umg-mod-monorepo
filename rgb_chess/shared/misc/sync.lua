
--[[
    basic syncing config
]]


sync.proxyEventToClient("buff")
sync.proxyEventToClient("debuff")


sync.proxyEventToClient("levelDown")
sync.proxyEventToClient("levelUp")


sync.autoSyncComponent("level")

