
require("xy_questions")


local xy = {}



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

