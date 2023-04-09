
local shieldAPI
if server then
shieldAPI = require("server.engine.sheilds")
end

return umg.extend("abstract_projectile", {
    rgbProjectileOnHit = function(projEnt, targetEnt)
        local shieldAmount = projEnt.shieldAmount
        local duration = projEnt.shieldDuration
        shieldAPI.createShield(targetEnt, shieldAmount, duration)
        umg.call("shield", targetEnt, shieldAmount)
    end,

    init = function(ent, x, y, options)
        assert(options.healAmount,"?")
        ent:superInit(x,y,options)
    end
})

