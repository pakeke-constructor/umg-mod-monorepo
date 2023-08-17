
# Dimensions mod

Allows separation of entities via keyword.

Think of a "dimension" as a realm where entities can exist in.




### DimensionVectors:
`DimensionVectors` are central to this mod.
They represent a concrete position in the universe.

They are just a table of the following shape:
```lua
{
    x = 1,
    y = 439,
    dimension = "nether" -- optional value (defaults to "overworld")
    z = 439, -- optional value (defaults to 0)
}
```



### Dimension controllers:
Each dimension has an entity that is controlling it.
This is the "controller" for that dimension.


A controller entity is created automatically when we create a dimension:
```lua
local ent = dimensions.createDimension("my_dimension")
-- `ent` is the controller entity for `my_dimension`
```

If the controller entity is deleted, then that dimension is destroyed.

We can also specify our own controller entities, by passing them in.
```lua
local portalEnt = entities.server.newPortal(...)
dimensions.createDimension("my_dimension", portalEnt)
--[[
    now, if the portal entity is deleted, the dimension is destroyed too.
]]
```

-----------------------

-----------------------

We can get the controller entity for a dimension with `dimensions.getController`:
```lua
local ent = dimensions.getController(dimension)
```
If the dimension doesn't exist, `nil` is returned.

We can store any data we want in this entity. For example:
- light level of the dimension.
- fog level
- ground texture


