
# List of Tech Debt; Things that should be changed.
Only list things that are either
(A) Easy to do,
or (B) of high importance.




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





Refactor terrain a bit:
Terrain should always be an entity!!!
None of this manual-generated-id rubbish; that's what entities are for






