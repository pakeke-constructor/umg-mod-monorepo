
# Abilities:

Okay:
We want cool emergent behaviour with abilities.

Stuff like:
- Abilities editing themselves
- Abilities trasferring between entities
- Abilities swapping filters and functionality
- Abilities triggering each other arbitrarily


=======================================


Abilities are composed of 4 parts:

```
- Trigger (what triggers ability)
    - (NO ARGS)

- Target (what the ability targets)  
    - args:  (sourceEnt) : returns Array<Entity>

- Filter (whether the ability should occur)
    - args:  (sourceEnt, targetEnt) : returns boolean

- Action (what happens when the ability triggers)
    - args:  (sourceEnt)

```




Creating abilities:
An ability should just be a regular table:

```lua

local ability = {
    trigger = "roundStart", -- On round start:
    target = "matching", -- for all matching allies,
    filter = "moreHealthThan", -- if the target has less health than me,
    action = "buffAttackSpeed" --buff attack speed by X
}


```
