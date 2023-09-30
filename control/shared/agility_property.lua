
require("control_questions")


local DEFAULT_AGILITY = 100

properties.defineProperty("agility", {
    base = "baseAgility",
    default = DEFAULT_AGILITY,

    getModifier = function(ent)
        return umg.ask("control:getAgilityModifier", ent) or 0
    end,
    getMultiplier = function(ent)
        return umg.ask("control:getAgilityMultiplier", ent) or 1
    end
})

