

# Properties mod

Ok.
I'm not sure if we actually want to have this mod....
But I'm going to do some planning for it regardless.

Beware of action bias!!!

--------------

Read [this article for explanation.](https://untitledmodgame.com/blog/properties)

------------------

All the `properties` mod does is provide infrastructure for handling Ticked properties.<br/>
That's it!

# API:
```lua

properties.define({
  name = "speed",
  getProperty = function(ent)
    return umg.ask("xy:getSpeed", ent)
  end,
  
  ticked = nil or 1 -- recalculates automatically once per tick
})

properties.recalculate(ent, "speed")

properties.exists(propertyName) -- return true/false

```

# Extra features:
Currently, I don't think this mod is worth it.<br/>
If we could achieve these features, i think it would be worth, tho:

- Other systems can mutate properties "dynamically".
ie, in rgb-chess, if we want to mutate speed,damage, or maxHealth, we should be able to fudge with all of these properties without knowing about any of the questions that are emitted.<br/>
hmmmm.... this could go against the `getProperty` method from before.

Do some more thinking.

### planning for dynamic property mutation:
We could use multiple `getProperty` handlers, which would allow the `properties` mod greater control with handle custom mutations:
```lua
-- alternative define idea:
properties.define({
  name = "maxHealth",
  getProperty = function(ent)
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
  end
})


--[[
  TODO: think of an API where we can actually mutate artitrary properties cleanly.

  We ideally want it:
    - stateless
    - per entity
    - agnostic w.r.t property name
]]

```

## Random idea 1:
Create a function that mutates a property on the fly:
```lua

--[[
  multiplies an entity's speed by 2 for 5 seconds
]]
properties.mutate({
  type = "multiply"
  target = ent,
  property = "speed",
  value = 2,
  duration = 5
})


```
On second thought; NO, this is bad, because it's stateful, and it's meaningless state too.

------------

Best solution:<br/>
Just use a generic question that asks a question for each property:
```lua

umg.answer("properties:getPropertyMultiplier", function(ent, property)
  ...
end)

umg.answer("properties:getPropertyModifier", function(ent, property)
  ...
end)

```

