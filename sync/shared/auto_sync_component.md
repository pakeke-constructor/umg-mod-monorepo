

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
    bidirectional = {
        shouldAcceptServerside = function(ent, compVal)
        --[[
            Whether the component value (compVal) should be accepted
            on serverside.
            For example, if the entity is moving too fast, then
            the player may be hacking. So return false to discard.
            Else, return true.
        ]]
        end,
        shouldForceSyncClientside = function(ent, compVal)
        --[[
            By default, client-syncing discards packets for entities that
            the client is controlling.
            This is because the client has more up-to-date data.
            (i.e. we don't want to lag behind the player's character.)
            However, sometimes we receive a component update that shouldn't
            be discarded.
            For example; if we are syncing `x` component,
            and the server has teleported the player entity far away.
            We don't want to discard that packet! (That would cause a desync)
            So this function should return true to indicate a force-sync.
        ]]
        end
    }
})

```













### OLD:
### Initial ideas for controllable auto sync:
```lua


--[[

Auto-sync for controllable components.

This is for syncing components that can be controlled by the player,
for example:
x, y, lookX, lookY, etc.




On clientside:
server ---> client syncing is done, but ONLY if the client doesn’t control the entity.
Clients should discard packets for entities that they are controlling,
unless the value should force a sync.

Lerp support, (same as sync.autoSyncComponent)





On serverside:
if ent is not controlled by sender, discard.

comp types are checked (i.e. check that x component is number)

put restrictions on the value of new packets.
- (For example; limit entity speed)





IDEA:
We have two functions:

shouldAcceptServerside(ent, new_value) -> boolean
- Whether a packet should be accepted on server-side.


shouldForceSyncClientside(ent, new_value) -> boolean
- Whether a packet should override existing data for 
- controllable entities on client-side.


EXAMPLE, for x position component:
{
    shouldAcceptServerside = function(ent, x1)
        local delta = ent.speed * (AVERAGE_DT) * SYNC_LEIGHWAY
        return abs(x1 - x2) < delta
    end
}

So for example, on serverside:
if the current ent.x = 10, and then client sends `ent.x -> 100`,
then shouldAcceptServerside is called.
Since `ent.speed = 20`, this function will return `false`,
and the packet will be denied.


]]

```