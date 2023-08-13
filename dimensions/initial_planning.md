

# Dimension groups:


### IDEA 1:
Downside of this idea:
We gotta define `onAdded` and `onRemoved` for every dimension
individually... which is terrible.
```lua

local groups = dimensions.groups("x", "y")

umg.on("@update", function()
    for _, dimensionGroup in ipairs(groups) do
        for _, ent in ipairs(dimensionGroup) do
            updateEnt(ent)
        end
    end
end)
```


### IDEA 2:
We create an abstract group object that represents all dimensions at once:
```lua
local group = dimensions.group("x", "y")

group:onAdded(function(ent)
    local dim = self:getDimension() -- "overworld"
end)

group:onRemoved(function(ent)
    local dim = self:getDimension() -- "overworld"
end)
```
Downside: We can't *really* iterate over this data structure.





# Dimension events:
We want to easily be able to isolate events per dimension.
Example, `explosion` event only happens in one dimension.

Note that this could also just be achieved by passing the dimension
into the event, like:
```lua
umg.call("explosion", "overworld", ...)
```
We want to do better.

### IDEA 1:
```lua
local dim = dimensions.getDimensionObject(ent)

dim:call("explosion", ...)
-- same for umg.ask
```
But this is kinda bad....





## IDEA 3:
We don't need anything fancy. Instead, we leave implementation details up
to the modder.

(So that includes passing in the dimension to `umg.call` events.)
```lua

dimensions.onAny("drawEntity", function(dimension, ...)

end)

```







## IDEA 4:
Scrap all previous ideas.
We don't need anything fancy;
dimensions are just the same as (x,y) position; and we don't really
have anything fancy for x,y.


## Design considerations:
What happens if an entity is moved to a non-existant dimension?
- The dimension is automatically created.




## CONFIRMED API:
Stuff that definitely makes sense to include:
```lua

dimensions.server.setDimension(ent, "new_dim")
-- Moves ent to "new_dim"

local dim = dimensions.getDimension(ent) -- "new_dim"
local dim = dimensions.getDimension(ent.dimension) -- same thing



dimensions.server.setDefaultDimension("overworld")
-- If entities aren't assigned a dimension, they will end up here.
local dim = dimensions.getDefaultDimension() -- "overworld"


local my_dim = dimensions.server.generateUniqueDimension("name") 
-- generates a new unique dimension name containing the word "name",
-- like `name_30948945845` or something.  Great for temporary dimensions.


dimensions.exists(dim) -- true/false, whether `dim` exists as a dimension


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

```




## How other mods should do stuff
```lua
weather.rain.setOptions(dim, {...})
weather.fog.setOptions(dim, {...})

rendering.setGroundTextures(dim,  {"tex1", ...})

light.setBaseLighting(dim,  {1,1,1})
light.setDayNightCycle(dim, {
    ...
})

```




### Option 1:
setters/getters for `ent.dimension`

PROS:
easier for dimensions mod to reason about
able to have callbacks for when an entity changes dimensions
efficient, since systems know when an ents dimension changes

CONS:
modders might forget to use getters
harder to reason about, feels more janky
potential for a desync between ent.dimension and it's actual dimension

### Option 2:
no setters/getters for `ent.dimension`

PROS:
more consistent with x,y. x,y positions don't use setters/getters
easier to understand
more bug resistant

CONS:
systems don't know when dimension changes

### BEST OPTION:

- no getters/setters
- dimensions mod automatically emits `dimensions:entityMoved`
    if an entity moves.











# question:
Should dimensions have an actual representation?
(like, as an object?)
Or should they just be ids?

### OPTION 1:
Dimensions don't actually exist, they are just string tags

PROS:
- more robust
- dont need to handle deletion/creation of dimensions

CONS:
- can't detect when a dimension is destroyed/created (no callbacks)


### OPTION 2:
Dimensions are kept track of by the dimensions mod

PROS:
- dimensionCreated and dimensionDestroyed callback are available
- can iterate over dimensions
- way better for chunk saving

CONS:
- less robust, error prone.
- Somehow need to handle deletion / creation of dimensions

*To better explore opt 2, we need to answer a few questions:*
- what happens if an entity goes to a non-existant dimension?
    - the dimension is created
- if no entities exist in a dimension, what happens to the dimension?
    - we could add an option to automatically delete dimensions that dont
        contain any entities?





