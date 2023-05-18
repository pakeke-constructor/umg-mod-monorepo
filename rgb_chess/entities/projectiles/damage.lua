
local abstractProjectile = require("shared.abstract.abstract_projectile")


return umg.extend(abstractProjectile, {
    rgbProjectileOnHit = function(projEnt, targetEnt)
        attack.attack(projEnt.sourceEntity, targetEnt)  
    end,

    init = function(ent, x, y, options)
        assert(options.attackDamage, "?")
        assert(options.sourceEntity, "?")
        -- todo: Do we need this here?
        ent:superInit(x,y,options)
    end
})
