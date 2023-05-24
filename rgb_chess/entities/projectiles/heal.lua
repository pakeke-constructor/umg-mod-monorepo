
local abstractProjectile = require("shared.abstract.abstract_projectile")


local abilities = require("shared.abilities.abilities")



return umg.extend(abstractProjectile, {
    rgbProjectileOnHit = function(projEnt, targetEnt)
        local healAmount = projEnt.healAmount
        targetEnt.health = math.min(targetEnt.maxHealth, targetEnt.health + healAmount)
        abilities.trigger("allyHeal", targetEnt.rgbTeam)
        umg.call("heal", targetEnt, healAmount)
    end,

    init = function(ent, x, y, options)
        assert(options.healAmount,"?")
        ent:superInit(x,y,options)
    end
})

