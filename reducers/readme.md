

# reducers mod

Exports a bunch of useful reducer functions to the global namespace.

--------------

Reducers are used in question-buses.


## Explanation of reducers:


There are multiple answers to questions when asking a question through a question bus.
But we want only 1 answer in total.

Reducers what we use to combine multiple answers into one.

For example:<br>
Lets say we want to get the speed multiplier for an entity:
```lua

umg.answer("getSpeedMultiplier", function(ent)
    -- if entity has superSpeed component, increase speed by 10 times!
    if ent.superSpeed then
        return 10
    end
    return 1 -- else, return 1. (no speed multiplier)
end)


umg.answer("getSpeedMultiplier", function(ent)
    if ent.potionEffect == "slowness" then
        -- if entity has slowness potion effect, decrease speed by half.
        return 0.5
    end
    return 1
end)




--[[
    be careful not to define question-answers multiple times:
    Now, whenever an entity has `superSpeed` component, it will
    travel 50 TIMES AS FAST.

    This is because the reducer multiplies this answer with
    the previous answer too.
]]
umg.answer("getSpeedMultiplier", function(ent)
    if ent.superSpeed then
        return 5
    end
    return 1
end)

```


```lua
local function MULT(a, b)
    return a * b
end


local speed = umg.ask("getSpeedMultiplier", MULT, ent)
-- MULT is our reducer.
-- `ent` is passed as an argument to the answerers.
--      (we can pass as many args as we want though.)

print("The speed multiplier of ent is: ", speed)


```

