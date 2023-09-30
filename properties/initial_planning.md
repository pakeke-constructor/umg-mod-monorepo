

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

# Best solution:
Just use a generic question that asks a question for each property:
```lua

umg.answer("properties:getPropertyMultiplier", function(ent, property)
  ...
end)

umg.answer("properties:getPropertyModifier", function(ent, property)
  ...
end)

```



# There are still some issues though!

### How do we configure recalculation?

Ideally, we want our properties to be "ticked properties".<br/>
But, perhaps sometimes we don't want to recalculate per tick....

IDEA: Have ticked recalculation be on by default.<br/>
To account for this, add an option: `noTickedRecalculation` to turn off ticked recalculation.

---------------

### Exclusion of entities

What happens if we want to exclude our entity from the calculation?

I.e. we give our entity a `damage` value, and don't want other systems to affect it?<br/>
Do we just say "tough nuts" and not allow this setup...? 

Yeah, honestly, I think thats the best call.
Having properties be "overridden" in an arbitrary manner would be weird.

-------------

### Instantiating properties and nice defaults

How do we signal that entities should be added to the property calculation pool?
Well, we could just take all entities that have the property... but that would be a bit funny, since that would mean we are setting the component, only for it to be instantly recalculated.

**IDEA:**<br/>
We also want to make it easy to just "set" base property values.<br/>
How about we have a `baseDamage` component or something,
defined with the property? ie:

```lua
properties.define("damage", {
  base = "baseDamage"
})
```

With this example, `ent.baseDamage` is automatically added to the `ent.damage` value upon recalculation.

Also, a nice side effect of this could be that entitys are automatically granted the `damage` component if it has `baseDamage` component.<br/>
This completely fixes are initialization problem.

--------------

### Entities without properties

Our setup has one glaring issue:
It only works on entities that have the `property`.
For example, our `speed` modifiers will only work on entities with
the `speed` component.

This is bad. Our previous setup had it so that entities didn't need
to have `speed` component; `xy:getSpeed` was still called globally
for all entities that needed speed.

Hmm...<br/>
I think this can be fixed by having a function we can call for defaults:
```lua
local prop = properties.get(ent, "speed")
-- or something similar to this...?
```
Internally, this would call `xy:getSpeed` and all the other questions.
This would allow us to have our cake and eat it too.

(If entity has a `.speed` component though, it returns that instead.)

----------------

### Giving entities properties

There should also be an easy way for entities to be given properties.
Perhaps just `ent.propertyName = X` would suffice...?<br/>
A common idiom could be
```lua
ent.propertyName = properties.get(ent, "propertyName")
```

Do some more thinking.

IDEA:
I think explicit is better than implicit.
how about we do
```lua
properties.add(ent, "propertyName")
-- adds `propertyName` to `ent``.
```


### What about entities that don't want to have a certain property?
for example, an entity that doesn't want to have `health` component?
Should this entity be able to say "no" to being given this property automatically...?

Because currently, the plan is:<br/>
If an entity receives a modifier for a property, the property is given to that entity,
(and thus the component is given to that entity too.)

SOLUTION: make it so that properties ARE NOT given to entities
automatically.<br/>
FUTURE OLI:  
Yeah this is a classic example of YOU overworking yourself, Oli.
Don't work when you are tired. You'll come up with stupid ideas like the original idea


