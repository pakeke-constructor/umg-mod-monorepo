

local properties = {}


local propertyList = {}

local propertyToConfig = {--[[
    [propertyName] -> config
]]}




local EMPTY = {}

local function makeGroup(comp, config)
    local extraComps = config.requiredComponents or EMPTY
    local group = umg.group(comp, unpack(extraComps))
    return group
end



local function makeBasePropertyGroup(property, config)
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
    local extraComps = config.requiredComponents or EMPTY
    local group = makeGroup(property, config)

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

    makeBasePropertyGroup(property, config)
    makePropertyGroup(property, config)
end








return properties

