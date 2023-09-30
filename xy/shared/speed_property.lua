
require("xy_questions")


local options = require("shared.options")


properties.defineProperty("speed", {
    base = "baseSpeed",
    default = options.DEFAULT_SPEED,

    getModifier = function(ent)
        return umg.ask("xy:getSpeedModifier", ent) or 0
    end,
    getMultiplier = function(ent)
        return umg.ask("xy:getSpeedMultiplier", ent) or 1
    end
})

