
# Abilities

Abilities are defined the same for items and units.

They can even be transferred between items and units.

```lua

defineAbility("test", {
    trigger = "onAllyDeath", 

    description = "When this unit dies, print hi",

    apply = function(ent, allyEnt)
        -- same args as filter
        print("hi")
    end,

    -- optional func:
    filter = function(ent, allyEnt)
    -- `ent` is the unit entity that contains the ability.
    -- (If ability is on an item, `ent` is the unit holding said item)

        -- if the ally dying is self, do the ability.
        return ent == allyEnt
    end,

    -- optional func:
    applyForItem = function(itemEnt, ent, allyEnt)
        -- This takes an extra first parameter, `itemEnt`.
        -- (Only called for item entities)
        print("hi from item!")
        -- (This is just to allow for extra extendability)
    end
})


```

