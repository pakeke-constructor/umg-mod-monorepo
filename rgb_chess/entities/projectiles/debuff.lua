
local abstractProjectile = require("shared.abstract.abstract_projectile")


local abilities = require("shared.abilities.abilities")


local BUFFTYPES = constants.BUFF_TYPES


local buffHandlers = {
    [BUFFTYPES.ATTACK_DAMAGE] = function(target, amount)
        if target.attackDamage then
            target.attackDamage = target.attackDamage + amount
            return true -- success
        end
    end,
    [BUFFTYPES.ATTACK_SPEED] = function(target, amount)
        if target.attackSpeed then
            target.attackSpeed = target.attackSpeed + amount
            return true -- success
        end
    end,
    [BUFFTYPES.SPEED] = function(target, amount)
        if target.speed then
            target.speed = target.speed + amount
            return true -- success
        end
    end,
    [BUFFTYPES.HEALTH] = function(target, amount)
        if target.health and target.maxHealth then
            target.health = target.health + amount 
            target.maxHealth = target.maxHealth + amount 
            return true -- success
        end
    end,
    [BUFFTYPES.SORCERY] = function(target, amount)
        if target.sorcery then
            target.sorcery = target.sorcery + amount 
            return true -- success
        end
    end
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
