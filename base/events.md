

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


# sparseUpdate()
Called every 3 frames.


# heavyUpdate()
Called every 60 frames.


# draw()
Called when everything should be rendered.


# newWorld(...)
Called upon creation of a new world.
`(...)` is just some arbitrary arguments.
TODO- do some more thinking around this.



# join(username, ent)
Called when a player joins the game, who controls  `ent`.


# leave(username, ent)
Called when a player leaves the game, who controls `ent`.

