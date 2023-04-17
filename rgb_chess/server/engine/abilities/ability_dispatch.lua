
--[[

This file is responsible for "activating" abilities,
and providing an API for manually activating abilities.


Abilities work the same on items, as they do on units.

NOTE: Each ability callback takes an implicit `self` as first argument!
`self` is the entity that contains the ability
]]

local abilities = require("shared.abilities.abilities")
local validTriggers = require("shared.abilities.triggers")


local abilityGroup = umg.group("abilities")


-- NOTE: these aren't actually umg groups!
local abilityGroups = {
--[[
    [triggerType] -> Set{ ent1, ent2, ... }
    -- list of entities that are triggered by `triggerType`
]]
}



local getABGroupTc = base.typecheck.assert("string")

local function getAbilityGroup(triggerType)
    getABGroupTc(triggerType)
    if not abilityGroups[triggerType] then
        abilityGroups[triggerType] = base.Set()
    end
    return abilityGroups[triggerType]
end


local function addToAbilityGroups(ent)
    for _, abilityName in ipairs(ent.abilities) do
        local ability = abilities.get(abilityName)
        local group = getAbilityGroup(ability.trigger)
        group:add(ent)
    end
end



local removeFromAbilityGroupTc = base.typecheck.assert("entity", "string")

local function removeFromAbilityGroup(ent, triggerType)
    removeFromAbilityGroupTc(ent, triggerType)
    local group = abilityGroups[triggerType] 
    if group:has(ent) then
        group:remove(ent)
    end   
end


local function removeFromAbilityGroups(ent)
    -- removes from all ability groups.
    for triggerType, _ in pairs(abilityGroups)do
        removeFromAbilityGroup(ent, triggerType)
    end
end


abilityGroup:onAdded(function(ent)
    addToAbilityGroups(ent)
end)

abilityGroup:onRemoved(function(ent)
    removeFromAbilityGroups(ent)
end)







local function tryApplyAbility(ability, ent, ...)
    if (not ability.filter) or ability.filter(ent, ...) then
        ability.apply(ent, ...)
        umg.call("ability", ability, ent, ...)
    end
end



local tryCallItemAbilities


local callTc = base.typecheck.assert("string", "entity", "entity")

local function applyAbilities(triggerType, ent, selfArg, ...)
    --[[
        selfArg is the first argument passed to ability.apply(...)

        It's always a Unit entity.
        For example, if an ability is on an item, `selfArg` will be the
        unit. `ent` will be the item itself.
    ]]
    callTc(triggerType, ent, selfArg)
    for _, abilityName in ipairs(ent.abilities) do
        local ability = abilities.get(abilityName)
        if ability.trigger == triggerType then
            tryApplyAbility(ability, selfArg, ...)
        end
    end
    tryCallItemAbilities(triggerType, ent, ...)
end




local tryCallItemAbilitiesTc = base.typecheck.assert("string", "entity")

function tryCallItemAbilities(triggerType, ent, ...)
    tryCallItemAbilitiesTc(triggerType, ent) 
    -- Tries to call abilities on items in an inventory
    if ent.inventory then
        local inventory = ent.inventory
        for x=1, inventory.width do
            for y=1, inventory.height do
                local item = inventory:get(x,y)
                if umg.exists(item) then
                    applyAbilities(triggerType, item, ent, ...)
                end
            end
        end
    end
end




--[[
    Offloads an event onto all other entities that have the ability,
    AND are in the same team.
]]
local function callForTeam(abilityType, rgbTeam, ...)
    local group = getAbilityGroup(abilityType)
    -- todo: this is kinda bad, we are doing a linear filter here.
    -- for future, we should keep track of each team's abilities individually.
    for _, ent in ipairs(group) do
        if rgb.sameTeam(rgbTeam,ent) and rgb.isUnit(ent) then
            applyAbilities(abilityType, ent, ent, ...)
        end
    end
end





local triggerTypeDealthWith = {}
-- This table is just for testing, to ensure we cover all triggerTypes.

local function handled(abilityType)
    -- This function is just for debug purposes, to ensure
    -- that we cover every single triggerType.
    triggerTypeDealthWith[abilityType] = true
end


local function proxyToAll(eventType, abilityType)
    -- Generates an in-line callback listener that offloads
    -- the event onto all entities with the required trigger.
    -- The same args are passed.
    umg.on(eventType, function(...)
        local group = getAbilityGroup(abilityType)
        for _, ent in ipairs(group)do
            if rgb.isUnit(ent) then
                applyAbilities(abilityType, ent, ent, ...)
            end
        end
    end)
    handled(abilityType)
end


local function proxyToTeam(eventType, abilityType)
    -- Same as proxyToAll, but filters by team.
    -- NOTE: This function only works if the callback takes an ent as first argument!
    umg.on(eventType, function(ent, ...)
        assert(umg.exists(ent), "this callback must have entity as first arg")
        local rgbTeam = ent.rgbTeam
        callForTeam(abilityType, rgbTeam, ent, ...)
    end)
    handled(abilityType)
end





proxyToTeam("entityDeath", "onAllyDeath")

proxyToTeam("buff", "onAllyBuff")
proxyToTeam("debuff", "onAllyDebuff")

proxyToTeam("summon", "onAllySummoned")
proxyToTeam("sold", "onAllySold")

proxyToTeam("rgbAttack", "onAllyAttack")
proxyToTeam("heal", "onAllyHeal")
umg.on("rgbAttack", function(attackerEnt, targetEnt, damage)
    callForTeam("onAllyDamage", targetEnt.rgbTeam, targetEnt, attackerEnt, damage)
end)
handled("onAllyDamage")

-- TODO: I don't think this callback exists yet
proxyToTeam("stun", "onAllyStun")

proxyToTeam("shieldBreak", "onAllyShieldBreak")
proxyToTeam("shieldExpire", "onAllyShieldExpire")

proxyToAll("reroll", "onReroll")

proxyToAll("startTurn", "onStartTurn")
proxyToAll("endTurn", "onEndTurn")
proxyToAll("startBattle", "onStartBattle")



-- We need to ensure all triggerTypes are being dealt with.
-- This is just for debug/safety purposes.
do
for _, triggerType in ipairs(validTriggers) do
    if not triggerTypeDealthWith[triggerType] then
        error("triggerType not dealt with: " .. triggerType)
    end
end
end


return abilities
