
local abstractProjectile = require("shared.abstract.abstract_projectile")


local abilities = require("shared.abilities.abilities")


local BUFFTYPES = constants.BUFF_TYPES


local buffHandlers = {
    [BUFFTYPES.ATTACK_SPEED] = function(target, amount)
        target.attackSpeed = target.attackSpeed - amount
    end,
    [BUFFTYPES.SPEED] = function(target, amount)
        target.speed = target.speed - amount
    end,
    [BUFFTYPES.HEALTH] = function(target, amount)
        target.health = target.health - amount 
        target.maxHealth = target.maxHealth - amount 
    end,
    [BUFFTYPES.POWER] = function(target, amount)
        target.health = target.health - amount 
    end,
}



do
    for btype,_ in pairs(BUFFTYPES)do
        assert(buffHandlers[btype],"?")
    end
end




return umg.extend(abstractProjectile, {
    rgbProjectileOnHit = function(projEnt, targetEnt)
        local btype = projEnt.buffType
        local sourceEnt = projEnt.sourceEntity
        local success = buffHandlers[btype](targetEnt, -projEnt.buffAmount)
        if success then
            abilities.trigger("allyDebuff", targetEnt.rgbTeam)
            umg.call("debuff", targetEnt, btype, projEnt.buffAmount, sourceEnt)
        else
            umg.call("debuffFailed", targetEnt, btype, projEnt.buffAmount, sourceEnt)
        end
    end,

    init = function(ent, x, y, options)
        assert(options.buffAmount, "requires buffAmount")
        ent:superInit(x,y,options)
    end
})
