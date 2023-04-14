--[[

Ability definitions

]]


local validTriggers = require("server.engine.abilities.triggers")
local abilityTypes = require("shared.ability_types")



local abilities = setmetatable({}, {
    __index = function(t,k)
        error("accessed undefined ability: " .. tostring(k))
    end
})



local function defineAbility(name, options)
    assert(options.description, "Needs description")
    assert(options.trigger and validTriggers[options.trigger], "Needs valid trigger")
    assert(type(options.apply) == "function", "Needs apply")
    assert((not options.filter) or type(options.filter) == "function", "?")

    assert(not rawget(abilities,name), "Duplicate ability name")

    abilities[name] = options
end




function abilities.get(abilityType)
    return abilities[abilityType]
end




defineAbility(abilityTypes.test, {
    trigger = "onAllyDeath", 
    description = "When die, print hi",
    filter = function(ent, allyEnt)
        return ent == allyEnt
    end,
    apply = function()
        print("hi")
    end
})




do
for abilType, _ in pairs(abilityTypes) do
    assert(abilities[abilType], "Undefined ability type: " .. abilType)
end
end


return abilities

