
--[[

This file is responsible for "activating" abilities,
and providing an API for manually activating abilities.


]]


local abilities = {}


local abilityGroup = umg.group("abilities")


--[[

Abilities work the same on items, as they do on units.

NOTE: Each ability callback takes an implicit `self` as first argument!
`self` is the entity that contains the ability

]]


local validTriggers = require("server.engine.abilities.triggers")





local function ensureTriggerMapping(ability)
    local trigger = ability.trigger or "nil"
    if not validTriggers[trigger] then
        error("Invalid ability trigger for entity: " .. ent:type() .. "  " .. trigger)
    end

    ent.abilities.triggerMapping[trigger] = ability
end



-- NOTE: these aren't actually umg groups!
local abilityGroups = {
--[[
    [triggerType] -> Set{ ent1, ent2, ... }
    -- list of entities that contain `triggerType`
]]
}



local getABGroupTc = base.typecheck.assert("string")

local function getAbilityGroup(abilityType)
    getABGroupTc(abilityType)
    if not abilityGroups[abilityType] then
        abilityGroups[abilityType] = base.Set()
    end
    return abilityGroups[abilityType]
end


local function addToAbilityGroups(ent)
    for _, ability in ipairs(ent.abilities) do
        local group = getAbilityGroup(ability.type)
        group:add(ent)
    end
end



abilityGroup:onAdded(function(ent)
    ensureTriggerMapping(ent)
    addToAbilityGroups(ent)
end)



local function tryGetAbility(ent, abilityType)
    return ent.ability.triggerMapping[abilityType]
end


local callTc = base.typecheck.assert("string", "entity")

local function call(abilityType, ent, ...)
    callTc(abilityType, ent)
    local abil = ent.abilities
    local handler = abil.triggerMapping[abilityType]
    if (not handler.filter) or handler.filter(ent, ...) then
        handler.apply(ent, ...)
        -- TODO: Surely we can do something better here?
        umg.call("ability", abilityType, ent, ...)
    end
end

abilities.applyAbility = call




--[[
    Offloads an event onto all other entities that have the ability,
    AND are in the same team.
]]
local function callForTeam(abilityType, rgbTeam, ...)
    local group = getAbilityGroup(abilityType)
    -- todo: this is kinda bad, we are doing a linear filter here.
    -- for future, we need to keep track of each team's abilities individually.
    for _, ent in ipairs(group) do
        if rgb.sameTeam(rgbTeam,ent) then
            call(abilityType, ent, ...)
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
    -- the abilityType onto all entities with the same args.
    umg.on(eventType, function(...)
        local group = getAbilityGroup(abilityType)
        for _, ent in ipairs(group)do
            call(abilityType, ent, ...)
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




-- ensure we covered all abilityTypes:
do
for _, triggerType in ipairs(validTriggers) do
    if not triggerTypeDealthWith[triggerType] then
        error("triggerType not dealt with: " .. triggerType)
    end
end
end


return abilities
