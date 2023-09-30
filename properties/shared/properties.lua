
require("properties_questions")


local properties = {}


local propertyList = {}

local propertyToConfig = {--[[
    [propertyName] -> config
]]}


local function getConfig(property)
    return propertyToConfig[property]
end


local function isProperty(property)
    return propertyToConfig[property], "expected property"
end

typecheck.addType("property", isProperty)




local function getBaseValue(ent, config)
    local baseProperty = config.base
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



local function makeBasePropertyGroup(property)
    assert(server,"?")
    local config = getConfig(property)
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


local function updateGroup(group, property, config)
    -- updates all entities in a group:
    for _, ent in ipairs(group) do
        ent.property = computeProperty(ent, property, config)
    end
end


local function makePropertyGroup(property)
    local config = getConfig(property)
    local group = makeGroup(property, config)
    
    local count = 1
    umg.on(tickEvent, function()
        local skips = config.skips or 1
        count = count + 1

        -- only update after we have skipped `skips` times.
        -- This allows us to make property calculation more "lazy"
        if count > skips then
            updateGroup(group, property, config)
            count = 1
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

function properties.declareProperty(property, config)
    defineTc(property, config)
    if propertyToConfig[property] then
        error("Property is already defined: " .. tostring(property))
    end

    propertyToConfig[property] = config
    table.insert(propertyList, property)

    if server then
        makeBasePropertyGroup(property)
        makePropertyGroup(property)
    elseif client then
        if config.shouldComputeClientside then
            makePropertyGroup(property)
        end
    end
end



local entpTc = typecheck.assert("entity", "property")

function properties.computeProperty(ent, property)
    entpTc(ent, property)
    local config = propertyToConfig[property]
    return computeProperty(ent, property, config)
end




return properties

