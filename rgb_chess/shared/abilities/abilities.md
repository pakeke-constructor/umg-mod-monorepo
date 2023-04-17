
# Abilities

Abilities are defined the same for items and units.

They can even be transferred between items and units.

```lua

defineAbility("test", {
    trigger = "onAllyDeath", 

    description = "When die, print hi",

    filter = function(ent, allyEnt)
    -- `ent` is the unit entity that contains the ability.
    -- (If ability on item, `ent` is the unit that is holding said item)
        return ent == allyEnt
    end,

    apply = function(ent, allyEnt)
        -- same args as filter
        print("hi")
    end,

    applyForItem = function(itemEnt, ent, allyEnt)
        -- This takes an extra first parameter, `itemEnt`.
        -- (Only called for item entities)
        print("hi from item!")
    end
})


```

