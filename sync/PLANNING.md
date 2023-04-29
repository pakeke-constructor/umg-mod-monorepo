

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
    noDeltaCompression = true, -- does delta-compression per entity
})


sync.defineEvent()




```

