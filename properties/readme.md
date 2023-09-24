

# Properties API:

```lua

-- alternative define idea:
properties.define({
    name = "maxHealth",
    getModifier = function(ent)
        -- additive property value
    end,

    getMultiplier = function(ent)
        -- (optional func)
        -- multiplier for property. 

        -- (If this func isn't supplied, multiplier is 1)
    end,

    onRecalculate = function(ent)
        -- (optional func)
        -- called when property is recalculated:
        ent.health = math.min(ent.health, ent.maxHealth)
        -- health can never be more than maxHealth
    end,
end
})



properties.recalculate(ent, "speed")

-- check if a property exists:
properties.exists(propertyName) -- return true/false


local props = properties.getAllProperties()



-- We also have two questions:
umg.answer("properties:getPropertyMultiplier", function(ent, property)
    ...
end)

umg.answer("properties:getPropertyModifier", function(ent, property)
    ...
end)

```


# Example usage:
```lua
--[[

What's beautiful about this setup, is that we can define systems 
that work with ALL properties automatically.

There's no more layers of glue required! It just "works".
Very cool.
]]

umg.answer("properties:getPropertyModifier", function(ent, property)
    if ent.effects then
        if ent.effects[property] then
            local efct = ent.potionEffects[property]
            return efct.strength
        end
    end
    return 0
end)

```
