

# SYNC MOD PLANNING:

```lua

sync.denoteEventProxy("hello") 
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
    IDEA: Auto filter API
]]
local sf = sync.filters

local filters = sync.filter(
    sf.controlEntity,
    sf.number,
    sf.number,
    sf.NumberInRange(-5, 5)
    sf.And(sf.inventoryEntity, sf.controlEntity)
)


sync.defineFilter("controlEntity", function(sender, x)
    return umg.exists(x) and x.controller == sender
end)

sync.defineFilter("inventoryEntity", function(sender, x)
    return umg.exists(x) and x.inventory
end)



```

