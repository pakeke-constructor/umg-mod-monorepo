
--[[

This file handles what happens when projectiles actually hit the target.

]]

local PROJTYPES = constants.PROJECTILE_TYPES
local BUFFTYPES = constants.BUFF_TYPES


local buffHandlers = {
    [BUFFTYPES.ATTACK_DAMAGE] = function(projectile, targetEnt)
        local amount = projectile.buffAmount
        targetEnt.attackDamage = targetEnt.attackDamage + amount
    end,
    [BUFFTYPES.ATTACK_SPEED] = function(projectile, targetEnt)
        local amount = projectile.buffAmount
        targetEnt.attackSpeed = targetEnt.attackSpeed + amount
    end,
    [BUFFTYPES.SPEED] = function(projectile, targetEnt)
        local amount = projectile.buffAmount
        targetEnt.speed = targetEnt.speed + amount
    end,
    [BUFFTYPES.HEALTH] = function(projectile, targetEnt)
        local amount = projectile.buffAmount
        targetEnt.health = targetEnt.health + amount
        targetEnt.maxHealth = targetEnt.maxHealth + amount
    end,
    [BUFFTYPES.SORCERY] = function(projectile, targetEnt)
        local amount = projectile.buffAmount
        targetEnt.sorcery = targetEnt.sorcery + amount
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
        -- TODO: Redo attack API.
        attack.attack(projectile.sourceEntity, targetEnt)  
    end,

    [PROJTYPES.HEAL] = function(projectile, targetEnt)
        -- TODO: Heal unit here        
    end,

    [PROJTYPES.SHIELD] = function(projectile, targetEnt)
        -- TODO: Shield unit here
    end,

    [PROJTYPES.BUFF] = function(projectile, targetEnt)
        local btype = projectile.buffType
        local sourceEnt = projectile.sourceEnt
        buffHandlers[btype](projectile, targetEnt)
        umg.call("buff", targetEnt, btype, projectile.buffAmount, sourceEnt, projectile.depth)
    end
}


do
for ptype,_ in pairs(PROJTYPES)do
    assert(buffHandlers[ptype],"?")
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
    for _, ent in ipairs(projectileGroup) do
        local targetEnt = ent.targetEntity
        if not umg.exists(targetEnt) then
            done(ent)
        end
    end
end)
