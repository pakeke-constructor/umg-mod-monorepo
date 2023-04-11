

local BUFFTYPES = constants.BUFF_TYPES


local buffHandlers = {
    [BUFFTYPES.ATTACK_DAMAGE] = function(target, amount)
        target.attackDamage = target.attackDamage + amount
    end,
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
    [BUFFTYPES.SORCERY] = function(target, amount)
        target.sorcery = target.sorcery + amount 
    end
}



do
    for btype,_ in pairs(BUFFTYPES)do
        assert(buffHandlers[btype],"?")
    end
end




return umg.extend("abstract_projectile", {
    rgbProjectileOnHit = function(projEnt, targetEnt)
        local btype = projEnt.buffType
        local sourceEnt = projEnt.sourceEntity
        buffHandlers[btype](targetEnt, -projEnt.buffAmount)
        umg.call("debuff", targetEnt, btype, projEnt.buffAmount, sourceEnt, projEnt.depth)
    end,

    init = function(ent, x, y, options)
        assert(options.buffAmount, "requires buffAmount")
        ent:superInit(x,y,options)
    end
})