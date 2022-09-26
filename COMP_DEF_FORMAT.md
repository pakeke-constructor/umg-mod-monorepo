


# We need a nice format to be able 
# to define components nicely

IDEA: create a format from markdown:
`components.md`


FORMAT EXAMPLE STARTS BELOW THIS LINE:
-------------------------------


# components:

To define components, we must use a ```lua ``` block.
Everything outside the lua block is ignored.


```lua

ent.x = 10
-- The x position of the entity
-- (Must not be shared)


ent.y = -5
-- The y position of the entity
-- (Must not be shared)

ent.image = "my_image"
-- the image name of the entity




```

