
# playersaves mod

This mod allows for user players to be saved across playthroughs.

For example:
User `Jim` joins, and leaves 10 minutes later.

With this mod, Jim's entity data is saved,
So when `Jim` joins back again, his player will be in the same position,
and will contain the same data!


## BIG BAD WARNING:
This mod serializes player entities automatically, and serialization is done
recursively.

If you have a player entity that contains/references many other entities, they
will ALL be serialized.<br>
This is BAD!
Watch out for this!



