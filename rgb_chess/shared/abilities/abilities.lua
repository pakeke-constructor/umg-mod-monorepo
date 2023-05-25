
local triggers = require("shared.abilities.triggers")
local actions = require("shared.abilities.actions")
local targets = require("shared.abilities.targets")
local filters = require("shared.abilities.filters")

local Board
if server then
    Board = require("server.board")
end


local abilities = {}





local abilityActionBuffer
if server then
    abilityActionBuffer = base.Heap(function(a,b)
        -- TODO: Do some checks to ensure that this is the right way around.
        return a.activateTime > b.activateTime
    end)
end





local bufferActionTc = typecheck.assert({
    sourceEntity = umg.exists,
    targetEntity = umg.exists,
    action = "table",
    level = "number"
})


local function bufferAction(bufAction)
    --[[
        buffers an ability, such that it will occur in the next X seconds,
        instead of instantly.
        This is a (crappy) way of avoiding infinite loops

        bufAction = {
            sourceEntity = entX,
            targetEntity = entY,
            action = <Action>
        }
    ]]
    bufferActionTc(bufAction)
    if abilityActionBuffer:size() > constants.MAX_BUFFERED_ABILITIES then
        -- Ok.... this is pretty bad, since in multiplayer, this will
        -- block ALL players from activating abilities.
        return
    end

    bufAction.activateTime = base.getGameTime() + constants.ABILITY_BUFFER_TIME
    abilityActionBuffer:insert(bufAction)
end




local function applyBufferedAction(bufAction)
    local action = bufAction.action
    local src = bufAction.sourceEntity
    local targ = bufAction.targetEntity
    local level = bufAction.level

    if umg.exists(targ) then
        if src == targ then
            -- self triggered the ability, so emit `selfAbility` trigger
            abilities.trigger("selfAbility", targ.rgbTeam)
        elseif src.rgbTeam == targ.rgbTeam then
            -- the ability was triggered by an ally instead
            abilities.trigger("allyAbility", targ.rgbTeam)
        end
        
        action:apply(src, targ, level)
    end
end







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
        todo: this is kinda inefficient and bad, to be calling every tick.
        who cares! :)
    ]]
    removeFromAbilityMapping(ent)
    addToAbilityMapping(ent)
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




local applyActionToTc = typecheck.assert("entity", "entity", "table", "number?")

local function applyActionTo(sourceEnt, targetEnt, action, level)
    applyActionToTc(sourceEnt, targetEnt, action, level)
    bufferAction({
        sourceEntity = sourceEnt,
        targetEntity = targetEnt,
        action = action,
        level = level or 1
        --[[
            TODO: Do some more thinking about level here.
            Do we want level to be inherited from somewhere else?
            Perhaps level could be inherited from the entity itself?
        ]]
    })
end



local applyAbilityTc = typecheck.assert("entity", "table")

local function applyAbility(unitEnt, ability)
    applyAbilityTc(unitEnt, ability)
    local target = targets.getTarget(ability.target)
    local action = actions.getAction(ability.action)
    local filts = ability.filters
    local level = ability.level

    local entities = target:getTargetEntities(unitEnt)
    for _, ent in ipairs(entities) do
        if filtersOk(unitEnt, ent, filts) then
            applyActionTo(unitEnt, ent, action, level)
        end
    end
end




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




local triggerTc = typecheck.assert("string", "string")

function abilities.trigger(triggerType, rgbTeam)
    triggerTc(triggerType, rgbTeam)
    assert(triggers.isValid(triggerType), "invalid trigger: " .. triggerType)

    local arr = triggerMapping[triggerType] or EMPTY
    for _, ent in ipairs(arr)do
        if ent.rgbTeam == rgbTeam then
            applyAbilitiesOfType(ent, ent.abilities, triggerType)
        end
    end
end


function abilities.triggerForAll(triggerType)
    for rgbTeam, _board in Board.iterBoards() do
        abilities.trigger(triggerType, rgbTeam)
    end
end


function abilities.clearBuffers()
    assert(server,"cant call on clientside")
    abilityActionBuffer:clear()
end


do
local neededKeys = {
    "trigger", "target", "action"
}

function abilities.isValidAbility(ability)
    --[[
        returns true if ability is a valid ability.
    ]]
    for _, key in ipairs(neededKeys)do
        if not ability[key] then
            return false
        end
    end

    if not actions.getAction(ability.action) then
        return false
    end
    if not targets.getTarget(ability.target) then
        return false
    end
    if not triggers.isValid(ability.trigger) then
        return false
    end

    return true
end

end



local triggerDirectlyTc = typecheck.assert("entity", "entity", "table", "number?")

function abilities.activateDirectly(sourceEnt, targetEnt, ability, level)
    --[[
        activates a specific ability action directly to an entity,
        without applying the filter. 
        If level is not given, defaults to ability level.
    ]]
    assert(server,"cant call on clientside")
    triggerDirectlyTc(sourceEnt, targetEnt, ability, level)
    assert(rgb.isUnit(sourceEnt), "?")

    level = level or ability.level
    applyActionTo(sourceEnt, targetEnt, ability, level)
end



function abilities.activateAll(ent)
    --[[
        activates all abilities inside of `ent`,
        including items.
    ]]
    assert(server,"cant call on clientside")
    assert(umg.exists(ent), "?")
    assert(rgb.isUnit(ent), "not a unit entity")

    applyAllAbilities(ent, ent.abilities or EMPTY)

    if ent.inventory then
        foreachPassiveItem(ent, function(_, item)
            if item.abilities then
                applyAllAbilities(ent, item.abilities)
            end
        end)
    end
end










if server then


local abilityGroup = umg.group("rgbUnit", "abilities")

abilityGroup:onAdded(function(ent)
    assert(ent:isRegular("abilities"), "abilities can't be shared")
    addToAbilityMapping(ent)
end)

abilityGroup:onRemoved(function(ent)
    removeFromAbilityMapping(ent)
end)



local function resetAbilities(abilityList)
    for _, abil in ipairs(abilityList)do
        abil.activationCount = 0
    end
end


function abilities.reset()
    for _, ent in ipairs(abilityGroup)do
        if ent.abilities then
            resetAbilities(ent.abilities) 
        end
        foreachPassiveItem(ent, function(ent, item)
            resetAbilities(item.abilities)
        end)
    end
end


umg.on("@tick", function()
    for _, ent in ipairs(abilityGroup)do
        --[[
            since entities can change abilities dynamically, 
            we update the ability mapping dynamically, just to make sure
            everything is fine.
        ]]
        updateAbilityMapping(ent)
    end

    -- Activate all buffered abilities that have passed their activation time
    local time = base.getGameTime()
    local bufAction = abilityActionBuffer:peek()
    while bufAction do
        if bufAction.activateTime <= time then
            applyBufferedAction(bufAction)
            abilityActionBuffer:pop()
            bufAction = abilityActionBuffer:peek()
        else
            bufAction = nil
        end
    end
end)

end



return abilities
