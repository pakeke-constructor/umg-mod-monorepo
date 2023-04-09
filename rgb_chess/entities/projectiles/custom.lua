

return umg.extend("abstract_projectile", {
    rgbProjectileOnHit = function(projEnt, targetEnt)
        projEnt.sourceEntity:projectileOnHit(targetEnt)
    end,

    init = function(ent, x, y, options)
        local src = options.sourceEntity
        assert(options.sourceEntity, "custom projectiles need a source entity")
        assert(src and src.projectileOnHit, "need to give a sourceEntity that has a .projectileOnHit callback")

        ent:superInit(x,y,options)
    end
})
