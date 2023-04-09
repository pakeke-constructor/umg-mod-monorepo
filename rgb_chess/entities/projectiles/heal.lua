

return umg.extend("abstract_projectile", {
    rgbProjectileOnHit = function(projEnt, targetEnt)
        local healAmount = projEnt.healAmount
        -- TODO: Actually heal the entity
        umg.call("heal", targetEnt, healAmount, projEnt.depth)
    end,

    init = function(ent, x, y, options)
        assert(options.healAmount,"?")
        ent:superInit(x,y,options)
    end
})

