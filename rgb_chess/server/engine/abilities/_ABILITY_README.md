

# Abilities:


Abilities are composed of 4 parts:

- Trigger (what triggers ability)
- Target (what the ability targets)
- Filter (whether the ability should occur)
- Action (what happens when the ability triggers)




Before we create abilities, we must define all the appropriate actions,
filters, targets, and triggers in the respective files.
From there, we can then simply create abilities using strings


Creating abilities:

```lua

local ability = newAbility({
    trigger = "roundStart", -- On round start:
    target = "matching", -- for all matching allies,
    filter = "moreHealthThan", -- if the target has less health than me,
    action = "buffAttackSpeed" --buff attack speed by X
})


```




Trigger:
(no args)

Target:
If the target is multiple entities, then the ability is applied/filtered to multiple entities.
(no args)



Filter:
a function that returns true/false, whether an ability should occur. (takes args:
(sourceEnt, targetEnt)



Action:
What happens when an ability triggers. Takes args:
(sourceEnt, targetEnt, level, depth)

