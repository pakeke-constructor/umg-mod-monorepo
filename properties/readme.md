

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

```

# Extra features:
Currently, I don't think this mod is worth it.<br/>
If we could achieve these features, i think it would be worth, tho:

- Other systems can mutate properties "dynamically".
ie, in rgb-chess, if we want to mutate speed,damage, or maxHealth, we should be able to fudge with all of these properties without knowing about any of the questions that are emitted.<br/>
hmmmm.... this could go against the `getProperty` method from before.

Do some more thinking.

### planning for dynamic property mutation:
Ok, so the big main issue, is that we can't *really* use a question
bus for obtaining property values, since that question bus would be polled for ALL existing properties.
```lua

-- alternative define:
properties.define({
  name = "speed",
  getProperty = function(ent)
    -- additive property value
  end,

  getMultiplier = function(ent)
    -- (optional function)
    -- multiplier for property. 

  end
})




```




