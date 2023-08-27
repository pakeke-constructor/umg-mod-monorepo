

### Holding entities:

Here's a basic entity that can hold a gun:
```lua

return {
    image = "blob",

    initXY = true

    init = function(ent)
        ent.lookX, ent.lookY = 0,0
        -- the X and Y position that this entity is looking at.
        -- (This will also determine the face direction, and the direction
        --   that the tool is facing)

        ent.inventory = items.Inventory({width=1, height=1})

        local gunItem = newGunItem()
        ent.inventory:add(1,1, gunItem)
    end
}

```

