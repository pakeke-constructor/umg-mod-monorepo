

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
ent.upgrade = {

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



-- add/remove upgrades
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
umg.on("items:itemMoved", function(ent, itemEnt)
    if isUpgrade(itemEnt) and ent.upgrades then
        ent.upgrades:addUpgrade(itemEnt)
    end
end)

umg.on("items:itemRemoved", function(ent, itemEnt)
    if isUpgrade(itemEnt) and ent.upgrades then
        ent.upgrades:removeUpgrade(itemEnt)
    end
end)


```


# Support for exotic upgrade types:

We want special upgrades.
ie. upgrades that do MORE than just mutate a property.

ie: 
When entity is on


