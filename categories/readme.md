
# categories mod
Allows modders to categorize entities, and do stuff with that.


```lua

-- an entity with a category:
local entityType = {
    "x", "y",
    image = "banana",
    category = "enemy"
}
return entityType

```


API:
```lua

categories.getSet("enemy")
-- returns a set of all the entities that `category = "enemy"`


categories.changeEntity(ent, "ally")
-- changes `ent`s category to "ally".


```

