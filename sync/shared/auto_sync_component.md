

Automatic component syncing facilities.

usage:

```lua
sync.autoSyncComponent(<compName>, options)
```


Options allows us to configure
- delta compression
- extra components required
- lerp for clientside to make number changes more smooth,
- etc.


------------------------------------------

## Example with all options:

```lua
sync.autoSyncComponent("x", {
    lerp = true, -- whether we lerp numbers
    numberSyncThreshold = 0.5, -- threshold for numbers to be lerped
    requiredComponents = {"vx"}, -- extra required components for sync
    noDeltaCompression = false, -- disable delta compression?

    syncWhenNil = true, -- sync when the component becomes nil?

    -- This flag means that the component will be synced
    -- bidirectionally,  client <---> server.
    controllable = {
        shouldAcceptServerside = function(ent, compVal)
        --[[
            Whether the component value (compVal) should be accepted
            on serverside.
            For example, if the entity is moving too fast, then
            the player may be hacking. So return false to discard.
            Else, return true.
        ]]
        end,
        shouldForceControllableSyncClientside = function(ent, compVal)
        --[[
            By default, client-syncing discards packets for entities that
            the client is controlling.
            This is because the client has more up-to-date data.
            However, sometimes we receive a component update that shouldn't
            be discarded.
            For example; if we are syncing `x` component,
            and the server has teleported the player entity far away.
            We don't want to discard that packet! (That would cause a desync)
            So this function should return false.
        ]]
        end
    }
})

```