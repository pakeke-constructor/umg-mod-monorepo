
local Board = require("server.board")


local abilityGroup = umg.group("abilities")




--[[

A list of valid abilities.

Abilities work the same on items, as they do on units.


NOTE: Each ability callback takes an implicit `self` as first argument!
`self` is the entity that contains the ability

]]
local validAbilities = {
    "onAllyDeath",-- (allyEnt)
--    "onEnemyDeath",-- (enemyEnt)    --TODO: This will be a bit harder

    "onAllyBuff",-- (buffType, amount, buffer_ent, depth )
    "onAllyDebuff",-- (buffType, amount, buffer_ent, depth )

    "onAllySummoned",-- (summonedEnt)
    "onAllySold",-- (soldEnt)
 
    "onAllyDamage",-- (allyVictimEnt, attackerEnt, damage)
    "onAllyHeal",-- (allyEnt, healerEnt, amount)
    "onAllyAttack",-- (allyEnt, targetEnt, damage)

    "onAllyStun",-- (stunnedAllyEnt, duration)

    "onAllyShieldBreak", -- (allyEnt)
    "onAllyShieldExpire", -- (allyEnt, shieldSize)

    "onAllyEquip", -- (allyEnt, itemEnt)
    "onAllyUnequip", -- (allyEnt, itemEnt)
 
    "onReroll",-- ()
    "onStartTurn",-- ()
    "onEndTurn",-- ()

    "onStartBattle"-- ()
}

for _, ability in ipairs(validAbilities) do
    validAbilities[ability] = true
end




local function ensureAbilityMapping(ent)
    if ent.abilities.abilityMapping then
        return
    end

    ent.abilities.abilityMapping = {}
    for _, ability in ipairs(ent.abilities) do
        local typ = ability.type or "nil"
        if not validAbilities[typ] then
            error("Invalid ability type for entity: " .. ent:type() .. "  " .. typ)
        end

        ent.abilities.abilityMapping[typ] = ability
    end
end



-- NOTE: these aren't actually umg groups!
local abilityGroups = {
--[[
    [abilityType] -> Set{ ent1, ent2, ... }
    -- list of entities that contain `abilityType`
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
    ensureAbilityMapping(ent)
    addToAbilityGroups(ent)
end)



local function tryGetAbility(ent, abilityType)
    return ent.ability.abilityMapping[abilityType]
end


local callTc = base.typecheck.assert("string", "entity")

local function call(abilityType, ent, ...)
    callTc(abilityType, ent)
    local abil = ent.abilities
    local handler = abil.abilityMapping[abilityType]
    if (not handler.activation) or handler.activation(ent, ...) then
        handler.apply(ent, ...)
        call("ability", ent, ...)
    end
end


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





local abilityTypeIsDealtWith = {}
-- This table is just for testing, to ensure we cover all abilityTypes.

local function handled(abilityType)
    -- This function is just for debug purposes, to ensure
    -- that we cover every single abilityType.
    abilityTypeIsDealtWith[abilityType] = true
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

-- TODO: I don't think this callback exists yet
proxyToTeam("stun", "onAllyStun")

proxyToTeam("shieldBreak", "onAllyShieldBreak")
proxyToTeam("shieldExpire", "onAllyShieldBreak")

proxyToAll("reroll", "onReroll")

proxyToAll("startTurn", "onStartTurn")
proxyToAll("endTurn", "onEndturn")
proxyToAll("startBattle", "onStartBattle")





-- ensure we covered all abilityTypes:
do
for _, abilityType in ipairs(validAbilities) do
    assert(abilityTypeIsDealtWith[abilityType], "ability type not dealt with")
end
end



