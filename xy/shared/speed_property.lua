
require("xy_questions")


local options = require("shared.options")


properties.declareProperty("agility", {
    base = "baseAgility",
    default = options.DEFAULT_SPEED,

    getModifier = function(ent)
        return umg.ask("control:getAgilityModifier", ent) or 0
    end,
    getMultiplier = function(ent)
        return umg.ask("control:getAgilityMultiplier", ent) or 1
    end
})

