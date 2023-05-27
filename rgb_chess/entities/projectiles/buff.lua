
--[[

todo: this is hot TRASH.

Why tf is there so much logic in an entity file??
What is this, OOP?????

For next time, extrapolate this to a system please.


]]

local abstractProjectile = require("shared.abstract.abstract_projectile")

local abilities = require("shared.abilities.abilities")



local BUFFTYPES = constants.BUFF_TYPES


local buffHandlers = {
    [BUFFTYPES.ATTACK_SPEED] = function(target, amount)
        target.attackSpeed = target.attackSpeed + amount
    end,
    [BUFFTYPES.SPEED] = function(target, amount)
        target.speed = target.speed + amount
    end,
    [BUFFTYPES.HEALTH] = function(target, amount)
        target.health = target.health + amount 
        target.maxHealth = target.maxHealth + amount 
    end,
    [BUFFTYPES.POWER] = function(target, amount)
        target.health = target.health + amount 
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
        buffHandlers[btype](targetEnt, projEnt.buffAmount)
        abilities.trigger("allyBuff", targetEnt.rgbTeam)
        umg.call("buff", targetEnt, btype, projEnt.buffAmount, sourceEnt)
    end,

    init = function(ent, x, y, options)
        assert(options.buffAmount, "requires buffAmount")
        ent:superInit(x,y,options)
    end
})
