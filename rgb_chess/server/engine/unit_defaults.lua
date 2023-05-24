
local triggers = require("shared.abilities.triggers")
local actions = require("shared.abilities.actions")
local targets = require("shared.abilities.targets")
local filters = require("shared.abilities.filters")

--[[

Sets defaults for unit stats

attackDamage <- defaultAttackDamage
... etc

]]

local function makeDefaultsGroup(defaultComponent, targetComponent)
    local group = umg.group(defaultComponent)
    group:onAdded(function(ent)
        ent[targetComponent] = ent[defaultComponent]
    end)
end


makeDefaultsGroup("defaultAttackDamage", "attackDamage")
makeDefaultsGroup("defaultAttackSpeed", "attackSpeed")
makeDefaultsGroup("defaultSpeed", "speed")
makeDefaultsGroup("defaultSorcery", "sorcery")


local defaultHealthGroup = umg.group("defaultHealth")

defaultHealthGroup:onAdded(function(ent)
    ent.maxHealth = ent.defaultHealth
    ent.health = ent.defaultHealth
end)









local function checkAbilityValid(ability, etypeName)
    -- quickly checks everything is valid
    local targ = targets.getTarget(ability.target)
    local act = actions.getAction(ability.action)

    if ability.filters then
        assert(type(ability.filters) == "table", etypeName)
        for _, filt in ipairs(ability.filters)do
            assert(filters.getFilter(filt), etypeName)
        end
    end
    
    assert(triggers.isValid(ability.trigger), etypeName)
    assert(targ, etypeName)
    assert(act, etypeName)
end


local defaultAbilityGroup = umg.group("defaultAbilities")


--[[
    copy default abilities over to entity
]]
defaultAbilityGroup:onAdded(function(ent)
    ent.abilities = ent.abilities or {}
    if ent.defaultAbilities.trigger then
        error("Must define a list of abilities, not a single ability as a table.  " .. tostring(ent:type()))
    end

    for _, abil in ipairs(ent.defaultAbilities)do
        checkAbilityValid(abil, ent:type())
        table.insert(ent.abilities, table.copy(abil, true))
    end
end)

