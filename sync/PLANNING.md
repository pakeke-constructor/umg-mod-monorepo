

# SYNC MOD PLANNING:

```lua

sync.defineEventProxy("hello") 
-- automatically routes umg.call("hello", ...) on server to a 
-- umg.call("hello", ...) on clientside.


-- automatically syncs component `x` in a server-authoritative fashion
sync.autoSyncComponent("x", {
    -- this options table is OPTIONAL.  The values are the defaults:
    syncWhenNil = false
    lerp = false, -- only works for numbers
    numberSyncThreshold = 0.05, -- difference between numbers to sync
    noDeltaCompression = false, -- turns off delta-compression
})



--[[
    TODO: Do some planning for all of this.
]]
sync.definePacket(packetName, {

})

sync.recievePacket(packetName, function(sender, ...)
    hello() 
end)

sync.sendPacket(packetName, ...)




```