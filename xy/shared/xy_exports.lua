
require("xy_questions")


local getSpeed = require("shared.get_speed")


local xy = {}



local getSpeedTc = typecheck.assert("entity")

function xy.getSpeed(ent)
    getSpeedTc(ent)
    return getSpeed(ent)
end


local options = require("shared.options")



local setOptionTc = typecheck.assert("string")

function xy.setOption(key, val)
    setOptionTc(key, val)
    options.setOption(key,val)
end


function xy.getOption(key)
    return options[key]
end




umg.expose("xy", xy)

