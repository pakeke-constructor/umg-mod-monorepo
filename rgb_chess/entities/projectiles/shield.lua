
local shieldAPI
if server then
shieldAPI = require("server.engine.shields")
end

return umg.extend("abstract_projectile", {
    rgbProjectileOnHit = function(projEnt, targetEnt)
        local shieldAmount = projEnt.shieldAmount
        local duration = projEnt.shieldDuration
        shieldAPI.createShield(targetEnt, shieldAmount, duration)
        umg.call("shield", targetEnt, shieldAmount)
    end,

    init = function(ent, x, y, options)
        assert(options.shieldAmount,"?")
        assert(options.shieldDuration,"?")
        ent:superInit(x,y,options)
    end
})

