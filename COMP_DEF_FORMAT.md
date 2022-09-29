


# We need a nice format to be able to define components nicely.

## (Also, we need a nice format to define `call` events nicely too.)

IDEA: create a format from markdown:
`components.md`
and
`events.md`


FORMAT EXAMPLE STARTS BELOW THIS LINE:
-------------------------------


# components:

To define components, we must use a ```lua ``` block.
Everything outside the lua block is ignored.


```lua


-- The x position of the entity
-- (Must not be shared)
ent.x = 10


-- The y position of the entity
-- (Must not be shared)
ent.y = -5


-- the image name of the entity
ent.image = "my_image"


```



# events:

TODO:
Differentiate serverside events from clientside events


```lua


-- called when some event occurs in the game (yada yada)
-- (This is just the description of the event, when its called)
call("someEvent", arg1: integer, arg2: string, arg3: entity)









```

