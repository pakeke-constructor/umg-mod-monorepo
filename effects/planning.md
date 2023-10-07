

# upgrades mod

Handles upgrades for entities, that modify properties and stuff.

The reason I created this file, is because I thought of 
a nice (and efficient) way to cache upgrades.


## idea / implementation:

IDEA:
Have `upgrades` be regular entities! (ie could be item entities)

-------------

When calculating properties,
we can take advantage of the fact that state *already exists.*
```lua

ent.upgrades = UpgradeManager({
    modifiers = {
        -- list of modifiers for all properties:
        -- (This just serves as an internal cache)
        maxHealth = 10,
        --[[
        this is the AGGREGATE maxHealth modifier 
        from ALL maxHeath upgrades.
        ]] 
        ...
    },
    multipliers = {
        -- list of multipliers for properties
        -- (Same as above; internal cache)
        speed = 0.9,
        --[[
        this is the AGGREGATE speed multiplier 
        from ALL speed upgrades.
        ]] 
    }

    upgrades = Set({
        -- a set of upgrade entities:
        upgradeEnt, upgradeEnt2
    })
})





-- Upgrade entities:
-- ie entities that *provide* the upgrades.
ent.upgrade = {
    ... -- info about what the upgrade does
}





umg.answer("properties:getPropertyMultiplier", function(ent, prop)
    if ent.upgrades then
        if ent.upgrades.multipliers[prop] then
            return ent.upgrades.multipliers[prop]
        end
    end
end)


umg.answer(...)
-- (same for `modifiers`)



-- add/remove upgrades:
UpgradeManager:addUpgrade(itemEnt)
UpgradeManager:removeUpgrade(itemEnt)
-- these should emit `:upgradeAdded` and :upgradeRemoved callbacks
-- (assuming that the upgrade WAS actually added/removed.)

UpgradeManager:getMultiplier(property)
UpgradeManager:getModifier(property)

UpgradeManager:recalculate(property?)
-- recalculates cache.
-- if property not specified, recalculates all properties.
-- This will also get rid of dead entities.





--[[
    Integration with items mod:
]]
local UpgradeSlotHandle = objects.Class("...", items.SlotHandle)

function UpgradeSlotHandle:onItemAdded(itemEnt)
    local ent = self:getOwner()
    if isUpgrade(itemEnt) and ent.upgrades then
        ent.upgrades:addUpgrade(itemEnt)
    end
end

function UpgradeSlotHandle:onItemRemoved(itemEnt)
    local ent = self:getOwner()
    if isUpgrade(itemEnt) and ent.upgrades then
        ent.upgrades:removeUpgrade(itemEnt)
    end
end

function UpgradeSlotHandle:canAddItem(itemEnt)
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

### We also want some more "meta" upgrades:
TODO: Maybe these are closer to "abilities" than "upgrades"...?

- Upon taking damage: this upgrade mimics a random upgrade for 5 seconds
    - Meta/reflective behaviour
    - Dynamicism. Able to change itself easily.

- Upon taking damage: Trigger all other upgrade abilities
    - Meta/reflective behaviour
    - Requires a well-defined `trigger` format

- On death: revive as 3 clones of yourself, and delete this upgrade.
    - This one is actually really easy, just delete self! :)


## IDEA: Split into `upgrade` and `passive`.
There are a types of upgrades:
- Upgrades:
    - stat up, when condition
    - do something each frame, when condition
- Passives:
    trigger, action
    - on trigger, do action
    - (We dont need targets/filters here, since we will emit an event.
        Future systems can use targets/filters if they want)


-------------



# Upgrade format:
TODO: We need to add some options to allow for cacheing.
Some upgrades will be computationally expensive.
Each entity should choose how much cacheing they should do; because the
entity itself will know (roughly) how expensive it is.

```lua
-- basic setup:
ent.upgrade = {
    property = "strength",
    multiplier = 1.5,
    modifier = 10,
}

-- Exact same as before, but using functions instead:
-- This allows us to do more exotic calculations! :)
ent.upgrade = {
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
ent.upgrade = {
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


# Passive format:
A "passive" is an action that is triggered.
```lua

ent.passive = {
    -- TODO: how should we do triggers? Do some thinking.
    trigger = "mortality:onDamage",

    -- an ``
    action = function(ent, ownerEnt)

    end
}
```












-------------


# How often should we automatically recalculate?
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
upgrades to explicitly state whether they are dynamic or static.

**SOLUTION:**<br/>
Upgrades are individual entities, right?
How about we allow for each entity to choose it's own cacheing behaviour.
This could be a bit bloat-y tho.

