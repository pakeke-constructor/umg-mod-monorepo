
local triggers = require("server.engine.abilities.triggers")
local actions = require("server.engine.abilities.actions")
local targets = require("server.engine.abilities.targets")
local filters = require("server.engine.abilities.filters")


local abilities = {}


local abilityGroup = umg.group("rgbUnit", "rgbAbilities")



local EMPTY = {}

local triggerMapping = {--[[

    [trigger1] -> { ent1, ent2, ent3 }
    [trigger2] -> { ent1, ent2 }

]]}




local function addToAbilityMapping(ent)
    for _, ability in ipairs(ent.abilities) do
        local trig = ability.trigger
        triggerMapping[trig] = triggerMapping[trig] or base.Set()
        triggerMapping[trig]:add(ent)
    end
end



local function removeFromAbilityMapping(ent)
    for _, ability in ipairs(ent.abilities) do
        local trig = ability.trigger
        if triggerMapping[trig] then
            triggerMapping[trig]:remove(ent)
        end
    end
end



local function updateAbilityMapping(ent)
    --[[
        todo: this is kinda inefficient and bad, to be calling every tick
        who care! :)
    ]]
    addToAbilityMapping(ent)
    removeFromAbilityMapping(ent)
end




local function filtersOk(sourceEnt, ent, filts)
    for _, f in ipairs(filts) do
        local filt = filters.getFilter(f)
        if not filt:filter(sourceEnt, ent) then
            return false
        end
    end
    return true
end



local function applyAbility(unitEnt, ability)
    local target = targets.getTarget(ability.target)
    local action = actions.getAction(ability.action)
    local filts = ability.filters

    local entities = target:getTargets(unitEnt)
    for _, ent in ipairs(entities) do
        if filtersOk(unitEnt, ent, filts) then
            action:apply(unitEnt, ent)
        end
    end
end


local function applyAbilities(ent)
    for _, ability in ipairs(ent.abilities)do
        applyAbility(ent, ability)
    end
end


local function applyAbilitiesOfType(ent, triggerType)
    for _, ability in ipairs(ent.abilities)do
        if ability.trigger == triggerType then
            applyAbility(ent, ability)
        end
    end
end



local triggerTc = typecheck.assert("string", "string")

function abilities.trigger(triggerType, rgbTeam)
    triggerTc(triggerType, rgbTeam)
    assert(triggers.TYPES[triggerType], "?")

    local arr = triggerMapping[triggerType] or EMPTY
    for _, ent in ipairs(arr)do
        if ent.rgbTeam == rgbTeam then
            applyAbilitiesOfType(ent, triggerTc)
        end
    end
end




abilityGroup:onAdded(function(ent)
    addToAbilityMapping(ent)
end)



abilityGroup:onRemoved(function(ent)
    removeFromAbilityMapping(ent)
end)




umg.on("@tick", function()
    --[[
        since entities can change abilities dynamically, 
        we update the ability mapping dynamically, just to make sure
        everything is fine.
    ]]
    for _, ent in ipairs(abilityGroup)do
        updateAbilityMapping(ent)
    end
end)

