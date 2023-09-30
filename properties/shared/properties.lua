
require("properties_questions")


local properties = {}


local propertyList = {}

local propertyToConfig = {--[[
    [propertyName] -> config
]]}



local function isProperty(property)
    return propertyToConfig[property], "expected property"
end

typecheck.addType("property", isProperty)




local function getBaseValue(ent, config)
    local baseProperty = config.baseProperty
    if baseProperty and ent[baseProperty] then
        return ent[baseProperty]
    end
    return config.default or 0
end


local function getMultiplier(ent, property)
    return umg.ask("properties:getPropertyMultiplier", ent, property)
end

local function getModifier(ent, property)
    return umg.ask("properties:getPropertyModifier", ent, property)
end


local function computeProperty(ent, property, config)
    local multiplier = 1 -- multiplicative modifier
    local modifier = getBaseValue(ent, config) -- additive modifier

    if config.getMultiplier then
        multiplier = multiplier * config.getMultiplier(ent)
    end
    if config.getModifier then
        modifier = modifier + config.getModifier(ent)
    end

    multiplier = multiplier * getMultiplier(ent, property)
    modifier = modifier + getModifier(ent, property)

    return modifier * multiplier
end





local EMPTY = {}

local function makeGroup(comp, config)
    local extraComps = config.requiredComponents or EMPTY
    local group = umg.group(comp, unpack(extraComps))
    return group
end



local function makeBasePropertyGroup(property, config)
    assert(server,"?")
    if not config.base then
        return -- no base property! return
    end

    -- the "base" value of the property for the entity.
    -- for example, `baseDamage`
    local baseProperty = config.base
    local group = makeGroup(property, config)

    group:onAdded(function(ent)
        -- all entities with [baseProperty] component get given the property
        if type(ent[baseProperty]) ~= "number" then
            error(baseProperty .. " component needs to be a number. Not the case for: " .. ent:type())
        end
        ent[property] = ent[baseProperty]
    end)
end



local tickEvent
if server then
    tickEvent = "@tick"
elseif client then
    tickEvent = "@update"
end



local function makePropertyGroup(property, config)

    local group = makeGroup(property, config)
    
    --[[
        TODO: We need to add for more finer-grained control here.
    ]]
    local skips = config.skips or 1
    scheduling.runEvery(skips, tickEvent, function()
        for _, ent in ipairs(group) do
            ent.property = computeProperty(ent, property)
        end
    end)
end




local configTableType = {
    base = "string?",
    default = "number?",
    requiredComponents = "table?",

    getModifier = "function",
    getMultiplier = "function",

    onRecalculate = "function?"
}
local defineTc = typecheck.assert("string", configTableType)

function properties.define(property, config)
    defineTc(property, config)
    if propertyToConfig[property] then
        error("Property is already defined: " .. tostring(property))
    end

    propertyToConfig[property] = config
    table.insert(propertyList, property)

    if server then
        makeBasePropertyGroup(property, config)
        makePropertyGroup(property, config)
    elseif client then
        if config.shouldComputeClientside then
            makePropertyGroup(property, config)
        end
    end
end



local getTc = typecheck.assert("entity", "property")

function properties.get(ent, property)
    getTc(ent, property)
    if ent[property] then
        return ent[property]
    end
    local config = propertyToConfig[property]
    if config.default then
        return config.default
    end
    -- TODO: Wtf do we do here????
    -- perhaps we should throw error instead??
    -- This whole thing is cursed, it's too generic.
    return 0 
end






return properties

