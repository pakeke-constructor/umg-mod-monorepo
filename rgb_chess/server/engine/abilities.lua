
local Board = require("server.board")


local abilityGroup = umg.group("abilities")



--[[
    Okay... this is a *bit* hacky,
    but basically all abilities are tied directly to callbacks.

    when the callback is emitted, then the ability is called.
]]
local validAbilities = {
    "onDeath",-- (ent)
    "onBuff",-- (ent, buffType, amount, buffer_ent, depth )
    "onDebuff",-- (ent, buffType, amount, buffer_ent, depth )
    
    "onBuy",-- (ent)
    "onSell",-- (ent)

    "onAllySummoned",
    "onAllySold",
    
    "onDamage",
    "onHeal",
    "onAttack",
    "onStun",

    "onAllyDeath",
    
    "onReroll",
    "onStartTurn",
    "onEndTurn",

    "onStartBattle",
    "onEndBattle"
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
    [abilityType] -> { ent1, ent2, ... }
    -- list of entities that contain `abilityType`
]]
}



local getABGroupTc = base.typecheck.assert("string")
local function getAbilityGroup(abilityType)
    getABGroupTc(abilityType)
    if not abilityGroups[abilityType] then
        abilityGroups[abilityType] = base.Array()
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





