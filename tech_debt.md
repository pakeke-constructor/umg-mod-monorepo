
# List of Tech Debt; Things that should be changed.
Only list things that are either
(A) Easy to do,
or (B) of high importance.




# TECH_DEBT_1
Refactor item holding entirely:
Currently, it uses `setInventoryHoldValues` to send the hold_x and hold_y of the item to the server; where the server broadcasts to clients.
From there, the clients render the item directly (not through the draw-system or anything)
This is a BAD way of doing things. 
Why? Well, if we want to create a `lantern` item, and add `light` component to
make the lantern emit light, then the light won't be emitted,
because the `lantern` is being drawn independently by `item_rendering.lua`.

A better way to do it would be to set the item position and rotation directly;
That way, it can be drawn normally though draw-system; and any special effects,
like particles, light, outlines, etc etc will still be applied normally :)


Also, change the `item_rendering` to include `lookX` and `lookY` components; should read off of these components.
ALSO: Maybe put this code in a separate file?? Like `look_direction.lua`
or something? It doesn't really make sense for it to be in `item_rendering.lua`.
Basically just split up the files a bit and clean everything up.

TODO: Should we put `lookX` and `lookY` in the base mod? -->
Maybe make a `look_direction.lua` file.
Implement auto-syncing for `lookX` and `lookY`.

------------------------------
PLANNING::::
`lookX` and `lookY` are auto-synced on clientside-serverside.
If an entity has `lookAtMouse = true`, then the `lookX` and `lookY` will face towards
mouse. (useful for player entities)

With item holding, each `itemHoldType` takes a holder `ent`, and the item `itemEnt`.
It's position, rotation, and scale will be determined by the protocol inside of
`item_holding.lua`.
These values are computed on BOTH serverside and clientside; thus, they don't need
to be sent over the network. only `lookX` and `lookY` need to be sent over.




# TECH_DEBT_2
Refactor terrain a bit:
Terrain should always be an entity!!!
None of this manual-generated-id rubbish; that's what entities are for




# TECH_DEBT_3
change `pickups.lua`.
It's kindof weird that an item can be picked up via `ent.holdItem`,
AND be picked up via `ent.inventory`.
Surely there's a more robust way to do it.




# TECH_DEBT_4
ent.inventoryCallbacks feels a bit "weird" to use.
Take a look around there are see what there is to change;
chances are, it's probably quite easy to change stuff.

