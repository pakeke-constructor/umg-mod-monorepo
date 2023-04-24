

# List of keywords / fields / events that are now deleted:



# PROBLEM SPACE:

Ideally, we DON'T want items to have a position component, as this makes
things messy.


However... the way hold items are currently drawn into the world is SUPER
clean.

# SOLUTION:
ITEM HOLDING:
When an item is being held, grant it an (x,y) position.
When it's no longer being held, remove it's (x,y) position.

Note that this also fixes the whole `.hidden` stuff; since entities won't
be drawn if they don't have (x,y), since they won't be within the drawSystem.


ITEM PICKUPS:
How about, ground items are stored inside a `groundItem` entity.
`groundItem` entity has a position, image, and inventory components.
The inventory is 1x1, and contains the item that is dropped on the ground.
(lets call it `item`)

When `groundItem` is picked up, it transfers `item` to the inventory
of whoever picked it up, using `inventory:swap`, and deletes itself.
(calls a callback too, etc)

we should have a `groundItem` component, that is automatically put into
a spatial partition. Then, all the entities with `canPickUpItems` component
look for `groundItem` entities to pick up.

SMOL PROBLEM:
By default, the items mod will create groundItem entities and put an item
inside of them.
Do we want to be able to override this behaviour?
Perhaps `item.setDropBehaviour(function(itemEnt) ... end)` could allow us
to override the default item dropping behaviour..?





### BUGS:

Item holding bug:
Item holding is just all-around buggy and SHITTY.
This is probably due to the weird `:removeComponent` stuff that's happening.
`removeComponent` may need more testing.


