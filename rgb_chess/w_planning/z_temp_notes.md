

# PROBLEM SPACE:
We want the ability to transfer abilities between entities.
Obviously, this means that abilities must be globally defined somewhere.

We also want the ability for effects to be reused per ability.

IDEA: Define abilities statically:
```lua

defineAbility("dice", {
    trigger = "onAllyBuff",
    description = "Ally buffed:\nIf there are no [color] allys, gain 2 rerolls",
    
    filter = function(ent)
        local units = rgbAPI.getUnits(ent.rgbTeam)
        units = units:filter(filters.notMatch(ent.rgb))
        return #units <= 0
    end,

    apply = function(ent)
        local board = rgbAPI.getBoard(ent.rgbTeam)
        board:addRerolls(2)
    end
})
```




### PROBLEM-2:

We have items, and units.
These two entity types can share the same abilities.

Issue:
Some abilities may only work on units,
and some abilities may only work on items.

For example:  `End of turn: gain +10% hp`
This ability must be written differently if it's on an item, or unit.


### PROPOSED SOLUTION TO PROBLEM-2:
Have item abilities automatically act on the entity that is holding them.
As in, the `apply(ent, ...)` function in an item, `ent` references the
unit entity, NOT the item entity.

This is quite a "clean" way of doing things, but it's a lot less
flexible.


To account for the lack of flexibility, we could have a separate function,
`applyForItem(itemEnt, holderEnt, ...)`, (within ability objects) that is 
also called when an item ability is activated.

```lua
defineAbility("reroll", {
    trigger = "onReroll", 
    description = "On reroll, print REROLL",

    applyForItem = function(itemEnt, holderEnt, ...)
        print("reroll from item!")
    end,
    apply = function(ent)
        print("REROLL")
    end
})

```
