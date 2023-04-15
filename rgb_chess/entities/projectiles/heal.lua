
local abstractProjectile = require("shared.abstract.abstract_projectile")



return umg.extend(abstractProjectile, {
    rgbProjectileOnHit = function(projEnt, targetEnt)
        local healAmount = projEnt.healAmount
        targetEnt.health = math.min(targetEnt.maxHealth, targetEnt.health + healAmount)
        umg.call("heal", targetEnt, healAmount, projEnt.depth)
    end,

    init = function(ent, x, y, options)
        assert(options.healAmount,"?")
        ent:superInit(x,y,options)
    end
})

