
local control = {}


local getAgility = require("shared.get_agility")


control.getAgility = getAgility

control.getPlayer = require("shared.get_player");


umg.expose("control", control)

return control
