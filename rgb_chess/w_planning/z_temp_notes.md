

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




### PROBLEM 2:

We have items, and units.
These two entity types can share abilities.

But they are different 



