--[[

Ability definitions

]]


local validTriggers = require("shared.abilities.triggers")


local abilityNameToObject = {}


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
    assert((not options.applyForItem) or type(options.applyForItem) == "function", "?")

    assert(not rawget(abilityNameToObject, name), "Duplicate ability name")

    abilityNameToObject[name] = options
    abilities[name] = name
end




function abilities.get(abilityType)
    return abilityNameToObject[abilityType]
end




defineAbility("test", {
    trigger = "onReroll", 
    description = "When die, print hi",
    filter = function(ent)
        return true
    end,
    apply = function(ent)
        print("reroll with args:",ent)
    end
})


defineAbility("reroll", {
    trigger = "onReroll", 
    description = "On reroll, print REROLL",
    apply = function(ent)
        print("REROLL")
    end
})



return abilities

