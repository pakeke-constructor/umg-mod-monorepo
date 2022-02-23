

## events
List of events defined by the base mod
==========================================================




# drawIndex(i)
Called when everything at Z order `i` should be drawn.
(Where `Z` index is defined by `floor((ent.pos.y + ent.pos.z)/2)`)


# drawEntity(ent)
Called whenever an entity is drawn


# damage(ent)
Called when an entity should take damage


# dead(ent)
Called when `ent` dies.


















### These are emitted internally, i.e. NOT by the base mod!




# update(dt)
Called every frame.
`dt` is the time between the last frame and this frame.


# update5()
Called every 5 frames.


# heavy60()
Called every 60 frames.


# tick
Called upon server tick. Server ticks usually occur 20-60 times per second;
but it depends on the configuration.


# draw()
Called when everything should be rendered.


# newWorld()
Called upon creation of a new world.  (Before entities spawn)


# join(username)
Called when a player joins the game


# leave(username)
Called when a player leaves the game

