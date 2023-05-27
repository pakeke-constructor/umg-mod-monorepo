
local abstractProjectile = require("shared.abstract.abstract_projectile")

local attack
if server then
    attack = require("server.battle.attack.attack")
end


return umg.extend(abstractProjectile, {
    rgbProjectileOnHit = function(projEnt, targetEnt)
        attack.attack(projEnt.sourceEntity, targetEnt)  
    end,

    init = function(ent, x, y, options)
        assert(options.damage, "?")
        assert(options.sourceEntity, "?")
        -- todo: Do we need this here?
        ent:superInit(x,y,options)
    end
})
