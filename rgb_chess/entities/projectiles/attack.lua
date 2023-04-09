
return umg.extend("abstract_projectile", {
    rgbProjectileOnHit = function(projEnt, targetEnt)
        attack.attack(projEnt.sourceEntity, targetEnt)  
    end,

    init = function(ent, x, y, options)
        assert(options.attackDamage, "?")
        -- todo: Do we need this here?
        ent:superInit(x,y,options)
    end
})
