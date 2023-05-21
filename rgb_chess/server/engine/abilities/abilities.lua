
local triggers = require("server.engine.abilities.triggers")
local actions = require("server.engine.abilities.actions")
local targets = require("server.engine.abilities.targets")
local filters = require("server.engine.abilities.filters")


local abilities = {}


local abilityGroup = umg.group("rgbUnit", "rgbAbilities")



local EMPTY = {}


local allTriggerTypes = triggers.getAllTriggerTypes()

local triggerMapping = {--[[

    [trigger1] -> { ent1, ent2, ent3 }
    [trigger2] -> { ent1, ent2 }

]]}




local function foreachPassiveItem(ent, func)
    -- applies a function for each passive item in inventory
    local inv = ent.inventory
    if not inv then
        return
    end

    for x=1, inv.width do
        for y=1, inv.height do
            local item = inv:get(x,y)
            if umg.exists(item) and rgb.isPassiveItem(item) then
                func(ent, item)
            end
        end
    end
end





local function addGivenAbilityList(ent, abilityList)
    --[[
        adds an entity to all appropriate abilityMapping arrays,
        given a list of abilities.
    ]]
    for _, ability in ipairs(abilityList) do
        local trig = ability.trigger
        triggerMapping[trig] = triggerMapping[trig] or base.Set()
        triggerMapping[trig]:add(ent)
    end
end


local function addToAbilityMapping(ent)
    --[[
        adds an entity to the abilityMapping.

        Takes into account ent abilities, AND entity passive items.
    ]]
    addGivenAbilityList(ent, ent.abilities)

    if ent.inventory then
        foreachPassiveItem(ent, function(_, item)
            if item.abilities then
                addGivenAbilityList(ent, item.abilities)
            end
        end)
    end
end



local function removeFromAbilityMapping(ent)
    --[[
        TODO: This is kinda inefficient and bad...
        But I don't see an alternative
    ]]
    for _, trig in ipairs(allTriggerTypes) do
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
    removeFromAbilityMapping(ent)
    addToAbilityMapping(ent, ent.abilities)
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




error[[
    TODO: 
    passive item abilities aren't supported.
    Add support for them here.
]]



local function applyAllAbilities(ent, abilityList)
    assert(rgb.isUnit(ent), "?")
    for _, ability in ipairs(abilityList)do
        applyAbility(ent, ability)
    end
end



local function applyAbilitiesOfType(ent, abilityList, triggerType)
    for _, ability in ipairs(abilityList)do
        if ability.trigger == triggerType then
            applyAbility(ent, ability)
        end
    end
end




local function applyEntitiesAbilitiesOfType(ent, triggerType)

end


local function applyAllEntityAbilities(ent)

end




local triggerTc = typecheck.assert("string", "string")

function abilities.trigger(triggerType, rgbTeam)
    triggerTc(triggerType, rgbTeam)
    assert(triggers.TYPES[triggerType], "?")

    local arr = triggerMapping[triggerType] or EMPTY
    for _, ent in ipairs(arr)do
        if ent.rgbTeam == rgbTeam then
            applyAbilitiesOfType(ent, ent.abilities, triggerTc)
        end
    end
end





local triggerDirectlyTc = typecheck.assert("entity", "table")

function abilities.activateAbilityDirectly(ent, ability)
    triggerDirectlyTc(ent, ability)
    assert(rgb.isUnit(ent), "?")

    applyAbility(ent, ability)
end



function abilities.activateEntityAbilitiesDirectly(ent)
    assert(umg.exists(ent), "?")
    assert(rgb.isUnit(ent), "not a unit entity")
    applyAbilities(ent)
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

