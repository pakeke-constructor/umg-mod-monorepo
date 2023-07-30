
local commands = {}



local values = require("shared.values")



local str_tc = typecheck.assert("string")

function commands.set(key, value)
    str_tc(key)
    values[key] = value
end


function commands.get(key, value)

end


return commands
