

# List of keywords / fields / events that are now deleted:

itemDrops
itemPickups

holdItem

inventory.public





# PROBLEM SPACE:

Ideally, we DON'T want items to have a position component, as this makes
things messy.


However... the way hold items are currently drawn into the world is SUPER
clean.

# SOLUTION:
When an item is being held, grant it an (x,y) position.
When it's no longer being held, remove it's (x,y) position.

Note that this also fixes the whole `.hidden` stuff; since entities won't
be drawn if they don't have (x,y), since they won't be within the drawSystem.


