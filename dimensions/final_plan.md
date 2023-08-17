

# dimensions mod


- no getters/setters for entities changing dimensions

- dimensions mod automatically emits `dimensions:entityMoved` if an entity changes dimensions.

- spatial partitions have a dimension value too



```lua
local dim = dimensions.getDimension(ent.dimension)


-- If entities aren't assigned a dimension, they will end up here.
local dim = dimensions.getDefaultDimension() -- "overworld"


local my_dim = dimensions.generateUniqueDimension("name") 
-- generates a new unique dimension name containing the word "name",
-- like `name_30948945845` or something.  Great for temporary dimensions.


local arr = dimensions.getAllDimensions() -- gets all dimensions



umg.on("dimensions:entityMoved", function(ent, oldDim, newDim)
    ... -- called when an entity moves dimensions
end)

umg.on("dimensions:dimensionCreated", function(dim_name)
    ... -- Called when a new dimension is created
end)

umg.on("dimensions:dimensionDestroyed", function(dim_name)
    ... -- called when a dimension is destroyed
end)




local ent = dimensions.server.createDimension(dimName, ent?)
-- creates a new dimension.
-- If an entity is passed in, this entity is the controller for this dim

dimensions.server.destroyDimension(dimName)
-- destroys a dimension




```

