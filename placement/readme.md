
# placement mod

### Usage:

-----------------------------


This is what a placeable entity should look like:
The entity that is being placed here is a "table".
```lua
-- table_item.lua

return placement.newPlaceable({
    itemName = "table";
    maxStackSize = 10;

    spawn = function(x,y)
        entities.table(x,y) -- this item places a table
    end;

    -- this component is where the real magic happens:
    placementRules = {
        {type = "closeTo", category = "foobar", amount = 4, distance = 50} 
        -- this item can only be placed within 
        -- 50 units of 4 entities in the `foobar` category
        {type = "awayFrom", category = "blah", distance = 20}
        -- this item can only be placed 20 units away 
        -- from an entity in the `blah` category
    }
})

```



Now for the actual world entity:
```lua

return {
    "x", "y",
    image = "table",
    ..., -- other components go here

    placementCategories = {
        "foobar", "grass" -- this entity belongs to foobar category and grass category.
    }
}

```
