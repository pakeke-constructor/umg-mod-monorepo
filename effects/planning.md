

# effects mod

Handles upgrades and passives for entities, 
that modify properties and provide effects.

Examples of effects:
- Armor
- Potion effects
- Upgrades (ie. +2 maxHealth)
- Passives (ie. explode on death)

^^^ All of these entities are examples of `effect`s!
They all use the same system, and IMO, that's *beautiful.*




## idea / implementation:

IDEA:
Have `effect` be regular entities! (ie could be item entities)

-------------

When calculating properties,
we can take advantage of the fact that state *already exists.*
```lua

ent.effects = EffectHandler({
    modifiers = {
        -- list of modifiers for all properties:
        -- (This just serves as an internal cache)
        maxHealth = 10,
        --[[
        this is the AGGREGATE maxHealth modifier 
        from ALL maxHeath effects.
        ]] 
        ...
    },
    multipliers = {
        -- list of multipliers for properties
        -- (Same as above; internal cache)
        speed = 0.9,
        --[[
        this is the AGGREGATE speed multiplier 
        from ALL speed effects.
        ]] 
    }

    effects = Set({
        -- a set of effect entities:
        effectEnt, effectEnt2
    })
})






umg.answer("properties:getPropertyMultiplier", function(ent, prop)
    if ent.upgrades then
        if ent.effects.multipliers[prop] then
            return ent.effects.multipliers[prop]
        end
    end
end)


umg.answer(...)
-- (same for `modifiers`)

umg.answer(...)
-- (same for clamps)



-- add/remove upgrades:
EffectHandler:addEffect(itemEnt)
EffectHandler:removeEffect(itemEnt)
-- these should emit `:effectAdded` and :effectRemoved callbacks
-- (assuming that the effect WAS actually added/removed.)

EffectHandler:getMultiplier(property)
EffectHandler:getModifier(property)
EffectHandler:getClamp(property)

EffectHandler:recalculate(property?)
-- recalculates cache.
-- if property not specified, recalculates all properties.
-- This will also get rid of dead entities.





--[[
    Integration with items mod:
]]
local EffectSlotHandle = objects.Class("...", items.SlotHandle)

function EffectSlotHandle:onItemAdded(itemEnt)
    local ent = self:getOwner()
    if isUpgrade(itemEnt) and ent.upgrades then
        ent.upgrades:addUpgrade(itemEnt)
    end
end

function EffectSlotHandle:onItemRemoved(itemEnt)
    local ent = self:getOwner()
    if isUpgrade(itemEnt) and ent.upgrades then
        ent.upgrades:removeUpgrade(itemEnt)
    end
end

function EffectSlotHandle:canAddItem(itemEnt)
    return isUpgrade(itemEnt)
end
--[[
    This would also work great with armor, boots, etc etc.
]]


```


# Support for exotic upgrade types:

We want special upgrades.
ie. upgrades that do MORE than just mutate a property.

ie: 
When entity is on fire:
    add +2 damage

**DO A LOT OF THINKING ABOUT THIS!!!**
This has the potential to be REALLY good.
Think of usable items, and how amazing/extensive they are.   
Surely we can emulate some of that awesomeness here, too?

Make sure to emit sufficient questions, and events!

Ok. I think the fairest way to evaluate how "effective" the upgrade
system is, is to come up with a bunch of upgrades that we would LIKE
to have, and then try to create a setup that would easily allow
for all those types.

### Ideas for what we want:

- When below 50% health, gain x2 strength
    - Conditional upgrades at runtime

- Lose 2 Max hp, +5 speed
    - Multi-property upgrades

- Gain 50% of maxHealth as strength, up to a maximum of 100
    - Incrementors that depend on other components/properties

- When lit on fire, emit a pulse of electricity
    - Responding to changes to holder entity; interacting with world

- If entity's inventory is full, gain +10 speed
    - Introspecting entity

- If taken damage in last 3 seconds, shoot cheese instead of bullets
    - Tagging onto events cleanly
    - Answering questions cleanly

- Upon picking up coins: have a 20% chance to double the pickup.
    - Tagging onto events cleanly

- Gives night vision
    - Answering questions cleanly


### We also want some more "meta" upgrades:
TODO: Maybe these are closer to "abilities" than "upgrades"...?

- Upon taking damage: this upgrade mimics a random upgrade for 5 seconds
    - Meta/reflective behaviour
    - Dynamicism. Able to change itself easily.

- Upon taking damage: Trigger all other effects this entity has
    - Meta/reflective behaviour
    - Requires a well-defined trigger format

- -5% speed. After 200 seconds, this effect deletes itself, 
        and all active effects are doubled in potency.
    - Meta/reflective behaviour

- On death: revive as 3 clones of yourself, and delete this upgrade.
    - This one is actually really easy, just delete self!

- On shoot bullet: Give all onDeath effects to the shot bullet
    - THIS ONE WOULD BE SO COOL! :D



## Split into parts: 

- propertyEffect:
    - modify property, when condition
- frameEffect:
    - do something each frame, when condition
- componentEffect:
    - ensure a component exists / change a component, when condition
    This is useful for stuff like `ent.fireResistance`, because we can
    set `ent.fireResistance=true` without needing to tap into the q-bus.
- triggerEffect:
    - triggers an ability by listening to events from an event-bus.
    - (We dont need targets/filters here, since we will emit an event.
        Future systems can use targets/filters if they want)
- answerEffect:
    answers a question from a question-bus.


-------------




# propertyEffect:
TODO: We need to add some options to allow for cacheing.
Some propertyEffects will be computationally expensive.
Each entity should choose how much cacheing they should do; because the
entity itself will know (roughly) how expensive it is.
```lua
-- basic setup:
ent.propertyEffect = {
    property = "strength",
    multiplier = 1.5,
    modifier = 10,
}
--[[
    TODO: Allow for cacheing!
]]

-- Exact same as before, but using functions instead:
-- This allows us to do more exotic calculations! :)
ent.propertyEffect = {
    property = "strength",
    shouldApply = function(ent, ownerEnt)
        return true -- if returns false, this upgrade doesnt apply
    end,
    multiplier = function(ent, ownerEnt)
        return 1.5
    end,
    modifier = function(ent, ownerEnt)
        return 10
    end
}

-- Exact same as before, but using multiple rules:
-- (This is useful if we want +5% health, -2% speed or something)
ent.propertyEffect = {
    {
        property = "strength",
        multiplier = 0.9
    },
    {
        property = "strength",
        modifier = 10
    }
}

```







# answerEffect:
We can use `answerEffect` to answer questions from question-buses
```lua

ent.answerEffect = {
    -- TODO: Plan this better, integrate this with
    -- effects.askQuestion
    question = "light:getGlobalLightSizeMultiplier",

    shouldAnswer = function(ent, ownerEnt)
        return true
    end,

    answer = 1.5
    answer = function(ent, ownerEnt, ...)
        -- `...` are extra arguments that are passed
        return 1.5 -- same as above
    end
}

```






# triggerEffect:
triggerEffects are 
```lua

ent.triggerEffect = {
    -- TODO: Plan this better, integrate this with
    -- effects.callEvent
    event = "mortality:onDamage",

    -- an `effects:isTriggerBlocked` question
    -- should be asked here (internally)
    shouldTrigger = function(ent, ownerEnt)
        return true
    end

    -- After this is triggered,
    -- a `effects:triggerEffect` event is emitted.
    trigger = function(ent, ownerEnt)
        -- do something
    end
}


-- using effects:isEventTriggerBlocked,
-- we can create a couple of good components:
ent.eventTriggerCooldown = 3 -- can only trigger once every 3 seconds

ent.eventTriggerActivations = 100 -- how many times it can trigger
-- (decreases by 1 every time it triggers)
-- We can use this to do stuff like: max 100 triggers per round
```

# Ability component:
We also need an `ability` so that our eventTrigger actually has an effect:
```lua
ent.ability = {
    canActivate = function(ent, ownerEnt)
        return true
    end,
    activate = function(ent, ownerEnt)
        -- do something.
    end
}


-- To activate an ability, use:
effects.activateAbility(abilityEnt, ownerEnt)
--[[
    This allows us to use abilities in a context that is unrelated
    to effects!
]]
-- Also: use buses when activating the ability, too:
-- `effects:isAbilityActivationBlocked` question
-- `effects:activateAbility` event

```


# Potion effect implementation:
We can support potions by adding a `lifetime` component
to an effect/passive entity.

this is honestly beautiful.
This essentially means that we can take ANY effect,
and convert it into a potion-effect.



-----------------


# SUPER IMPORTANT:
Could it be possible to reduce the coupling between `EffectHandler`
and `effect`/`passive` entities to zero?

Similar to how `usables` was de-coupled from the `Inventory`...?

^^^ If this is too difficult, dont do it.
But PLEASE. At least try to do it this way.
take the `usables` and `Inventory` de-coupling as the golden example.






# Tagging onto events/questions:
How do we tag onto events cleanly?
For example, say that one of our `passive` items wants to respond
to the `projectiles:getProjectileType` question.<br/>
How should we allow this response?

Perhaps an api:
`effects.callEvent(ent, eventName)`:
Dispatches an event to `ent`, (iff `ent` has .effects component)

Same for questions: `answer = effects.askQuestion(ent, questionName)`

Example:
```lua
umg.on("items:itemMoved", function(ownerEnt, item, sx, sy)
    effects.dispatchEvent("items:itemMoved", ownerEnt, item, sx, sy)
end)
```
We *could* do this automatically, like `sync.autoSyncComponent`...<br/>
But the reason we dispatch it manually, is because for some events,
`ownerEnt` may be in a different order.<br/>
Its cleaner and less fragile if we be explicit, rather than assuming
that `ownerEnt` is passed first.






-------------


# How often should we automatically recalculate properties?
OK.
Obviously, this is a bit awkward. 
We want dynamic upgrades. ie. per-tick recalculation.

but our cacheing mechanism allows us to be super efficient,
and only recalculate when an upgrade is added/removed.

However, if we only recalculate when an upgrade is added/removed,
then we aren't really able to have dynamic upgrades.<br/>
For example:
    double damage when on <50% health

We want the best of both worlds.
What if we keep two lists, one for `dynamic` upgrades, and one for
`static` upgrades...?

hmmm... this could be fragile, since that would require
upgrades to explicitly know whether they are dynamic or static.
And thats just dumb.

**SOLUTION:**<br/>
Upgrades are individual entities, right?
How about we allow for each entity to choose it's own cacheing behaviour.

