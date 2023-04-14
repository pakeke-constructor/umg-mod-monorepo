
local validTriggers = require("server.engine.abilities.triggers")


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




defineAbility("test", {
    trigger = "onAllyDeath", 
    description = "When die, print hi",
    filter = function(ent, allyEnt)
        return ent == allyEnt
    end,
    apply = function()
        print("hi")
    end
})




return abilities

