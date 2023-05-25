
# Abilities:

Okay:
We want cool emergent behaviour with abilities.

Stuff like:
- Abilities editing themselves
- Abilities trasferring between entities
- Abilities swapping filters and functionality
- Abilities triggering each other arbitrarily
- Abilities on one entity, applying to another entity


=======================================


Abilities are composed of 4 parts:

```
- Trigger (what triggers ability)
    ---> causes ability to trigger

- Target (what the ability targets)  
    - args: (sourceEnt) : returns Array<Entity>

- Filter (whether the ability should occur)
    - args:  (sourceEnt, targetEnt) : returns boolean

- Action (what happens when the ability triggers)
    - args:  (sourceEnt, targetEnt)

```




Creating abilities:
An ability should just be a regular table:

```lua

local ability = {
    trigger = "roundStart", -- On round start:
    target = "matching", -- for all matching allies,
    filters = {"moreHealthThan", "notSelf"},
    -- if the target has less health than me, and is not self
    action = "buffAttackSpeed" --buff attack speed by X

    -- optional fields:
    maxActivations = 200 or constants.MAX_ABILITY_ACTIVATIONS

    -- internally used fields:
    activationCount = 0 -- set and used internally
}


```

