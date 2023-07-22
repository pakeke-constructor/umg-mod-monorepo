

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



