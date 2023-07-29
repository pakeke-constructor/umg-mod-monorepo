
local abilities = require("shared.abilities.abilities")



umg.on("mortality:entityDeath", function(ent)
    if rgb.isUnit(ent) and ent.rgbTeam then
        abilities.trigger("allyDeath", ent.rgbTeam)
    end
end)

