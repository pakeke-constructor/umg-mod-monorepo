
--[[

This file handles what happens when projectiles actually hit the target.

]]

local PROJTYPES = constants.PROJECTILE_TYPES
local BUFFTYPES = constants.BUFF_TYPES


local buffHandlers = {
    [BUFFTYPES.ATTACK_DAMAGE] = function(projectile, targetEnt, mult)
        local amount = projectile.buffAmount
        targetEnt.attackDamage = targetEnt.attackDamage + amount * mult
    end,
    [BUFFTYPES.ATTACK_SPEED] = function(projectile, targetEnt, mult)
        local amount = projectile.buffAmount
        targetEnt.attackSpeed = targetEnt.attackSpeed + amount * mult
    end,
    [BUFFTYPES.SPEED] = function(projectile, targetEnt, mult)
        local amount = projectile.buffAmount
        targetEnt.speed = targetEnt.speed + amount * mult
    end,
    [BUFFTYPES.HEALTH] = function(projectile, targetEnt, mult)
        local amount = projectile.buffAmount
        targetEnt.health = targetEnt.health + amount * mult
        targetEnt.maxHealth = targetEnt.maxHealth + amount * mult
    end,
    [BUFFTYPES.SORCERY] = function(projectile, targetEnt, mult)
        local amount = projectile.buffAmount
        targetEnt.sorcery = targetEnt.sorcery + amount * mult
    end
}



do
for btype,_ in pairs(BUFFTYPES)do
    assert(buffHandlers[btype],"?")
end
end


local hitHandlers = {
    [PROJTYPES.CUSTOM] = function(projectile, targetEnt)
        projectile.sourceEntity:projectileOnHit(targetEnt)
    end,

    [PROJTYPES.DAMAGE] = function(projectile, targetEnt)
        attack.attack(projectile.sourceEntity, targetEnt)  
    end,

    [PROJTYPES.HEAL] = function(projectile, targetEnt)
        local healAmount = projectile.healAmount
        umg.call("heal", targetEnt, healAmount, projectile.depth)
    end,

    [PROJTYPES.SHIELD] = function(projectile, targetEnt)
        local shieldAmount = projectile.shieldAmount
        umg.call("shield", targetEnt, shieldAmount, projectile.depth)
    end,

    [PROJTYPES.BUFF] = function(projectile, targetEnt)
        local btype = projectile.buffType
        local sourceEnt = projectile.sourceEntity
        local multiplier = 1 -- buffing has a 1x multiplier, debuffing -1x mult.
        buffHandlers[btype](projectile, targetEnt, multiplier)
        umg.call("buff", targetEnt, btype, projectile.buffAmount, sourceEnt, projectile.depth)
    end,

    [PROJTYPES.DEBUFF] = function(projectile, targetEnt)
        local btype = projectile.buffType
        local sourceEnt = projectile.sourceEntity
        local multiplier = -1 -- buffing has a 1x multiplier, debuffing -1x mult.
        buffHandlers[btype](projectile, targetEnt, multiplier)
        umg.call("debuff", targetEnt, btype, projectile.buffAmount, sourceEnt, projectile.depth)
    end
}


do
for ptype,_ in pairs(PROJTYPES)do
    assert(hitHandlers[ptype],ptype)
end
end


local function done(projectileEnt)
    -- called when a projectile is done it's journey
    -- TODO: Maybe offload sfx or something?
    base.server.kill(projectileEnt)
end



umg.on("rgbProjectileHit", function(projectileEnt, targetEnt)
    if umg.exists(targetEnt) and umg.exists(projectileEnt.sourceEntity) then
        hitHandlers[projectileEnt.projectileType](projectileEnt, targetEnt)
    end
    done(projectileEnt)
end)



local projectileGroup = umg.group("rgbProjectile")

umg.on("@tick", function()
    --[[
        check for projectiles whose target has been deleted.
        If the target no longer exists, mark projectile as done.
    ]]
    for _, ent in ipairs(projectileGroup) do
        local targetEnt = ent.targetEntity
        if not umg.exists(targetEnt) then
            done(ent)
        end
    end
end)
