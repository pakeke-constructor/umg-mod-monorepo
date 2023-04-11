
local Board = require("server.board")


local abilityGroup = umg.group("abilities")




--[[

A list of valid abilities.

Abilities work the same on items, as they do on units.

]]
local validAbilities = {
    "onDeath",-- (ent)
    "onAllyDeath",-- (ent, allyEnt)
--    "onEnemyDeath",-- (ent, enemyEnt)  TODO: This will be harder to do

    "onBuff",-- (ent, buffType, amount, buffer_ent, depth )
    "onDebuff",-- (ent, buffType, amount, buffer_ent, depth )

    "onAllySummoned",-- (ent, summonedEnt)
    "onAllySold",-- (ent, soldEnt)
    
    "onDamage",-- (ent, attackerEnt, damage)
    "onHeal",-- (ent, healerEnt, amount)
    "onAttack",-- (ent, targetEnt, damage)

    "onStun",-- (ent, duration)
    "onAllyStun",-- (ent, stunnedAlly, duration)

    "onBreakShield",-- (ent)  when ent's shield is broken
    "onAllyBreakShield", -- (ent, allyEnt)
    
    "onReroll",-- (ent)
    "onStartTurn",-- (ent)
    "onEndTurn",-- (ent)

    "onStartBattle",-- (ent)
    "onEndBattle"-- (ent)
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



local function call(abilityType, ent, ...)
    local abil = ent.abilities
    local handler = abil.abilityMapping[abilityType]
    if (not handler.activation) or handler.activation(ent, ...) then
        handler.apply(ent, ...)
    end
end


local function callForTeam(abilityType, rgbTeam, ...)
    local group = getAbilityGroup(abilityType)
    for _, ent in ipairs(group) do
        if rgb.sameTeam(rgbTeam,ent) then
            call(abilityType, ent, ...)
        end
    end
end

