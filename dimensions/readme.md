
# Dimensions mod

Allows separation of entities via keyword.

Think of a "dimension" as a realm where entities can exist in.


To put an entity inside a dimension, simply change the `.dimension` component:
```lua
ent.dimension = "my_dimension"
-- now `ent` is inside of `my_dimension`
-- If `my_dimension` doesn'
```
If `ent.dimension` is nil, the entity is in the default dimension.

We can also create/destroy dimensions:
```lua
local ent = dimensions.createDimension("nether")

dimensions.createDimension("yomi")
```



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



### Dimension overseers:
Dimensions are represented by a single entity internally.

It is created automatically when we create a dimension:
```lua
local ent = dimensions.createDimension("my_dimension")
-- `ent` is the overseer entity for `my_dimension`
```

If the "overseer entity" is deleted, then that dimension is destroyed.

We can also specify our own overseer entities, by passing them in:
```lua
local portalEnt = entities.server.newPortal(...)

-- generate a unique dimension name. This is guaranteed to be unique,
-- and is guaranteed to contain the string passed in:
local dimensionName = dimensions.generateUniqueDimension("portal")
-- dimensionName:  portal_3894495845845453489

dimensions.createDimension("my_dimension", portalEnt)
-- now, if portalEnt is deleted, the dimension is destroyed too.
```

-----------------------

-----------------------

We can get the overseer entity for a dimension with `dimensions.getOverseer`:
```lua
local ent = dimensions.getOverseer(dimension)
if ent == nil then
    print("dimension doesn't exist: ", dimension)
else
    print("The overseer for this dimension is: ", ent)
end
```

We can store any data we want in this entity. For example:
- light level of the dimension
- fog density
- ground texture


