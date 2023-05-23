
local abilities = require("shared.abilities.abilities")



umg.on("entityDeath", function(ent)
    abilities.trigger("allyDeath", ent.rgbTeam)
end)

