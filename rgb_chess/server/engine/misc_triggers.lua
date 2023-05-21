
local abilities = require("server.abilities.abilities")


umg.on("entityDeath", function(ent)
    abilities.trigger("allyDeath", ent.rgbTeam)
end)

