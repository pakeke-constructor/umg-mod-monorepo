
local abilities = require("server.abilities.abilities")




umg.on("entityDeath", function(ent)
    abilities.trigger("allyDeath", ent.rgbTeam)
end)


umg.on("buff", function(targetEnt, btype, buffAmount, sourceEnt)
    abilities.trigger("allyBuff", targetEnt.rgbTeam)
end)


umg.on("debuff", function(targetEnt, btype, buffAmount, sourceEnt)
    abilities.trigger("allyDebuff", targetEnt.rgbTeam)
end)



