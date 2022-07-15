
# spatial_partition


Spatial partitioners are data structures used to seperate and update objects depending on their position.

This allows us to reduce the time taken to check interactions between objects, as we only need to check for interactions within certain areas.

The biggest catch with this library is that the objects need to have `.x` and `.y` attributes. If this isn't the case, and the `x` and `y` is stored somewhere else, you'll have to use either `partition:setGetters(getx, gety)` or `partition:setProxys(name_x, name_y)` to allow the spatial partitioner to read your object's position.


# usage:

```lua
local Partition = require("path.to.spatial_partition.partition")

-- cells of dimension:   100x, 120y.
local partition = Partition( 100, 120 )



-- Adds `obj` to spatial partition.
-- All objects must have `x` and `y` attributes.   (to change this, see below.)
partition:add( obj )


-- Removes object from partition
partition:remove( obj )



-- Compulsory! must be called each frame
partition:update()


partition:clear() --clears spatial partition


-- iterates over objects near `obj`, including `obj` itself.
-- (cells next to obj's cell will be included in the iteration.)
for object in partition:foreach(obj) do
    ...
end


-- Equivalent to above; direct positions can also be used
for object in partition:foreach( obj.x,  obj.y ) do
    ...
end
```


### Optional functionality:


```lua
partition:frozen_add(objec)
-- Adds `objec` to spatial partition, but will not move `objec` to other cells.
-- Is an efficient way of dealing with unmoving objects.
```
