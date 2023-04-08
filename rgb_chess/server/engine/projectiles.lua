

local PROJTYPES = constants.PROJECTILE_TYPES

local hitHandlers = {
    [PROJTYPES.CUSTOM] = function(projectile, targetEnt)
        projectile.sourceEntity:projectileOnHit(targetEnt)
    end,

    [PROJTYPES.DAMAGE] = function(projectile, targetEnt)
        attack.attack(projectile.sourceEntity, targetEnt)  
    end,

    [PROJTYPES.HEAL] = function(projectile, targetEnt)
        -- TODO: Heal unit here        
    end,

    [PROJTYPES.SHIELD] = function(projectile, targetEnt)
        -- TODO: Shield unit here
    end,

    [PROJTYPES.BUFF] = function(projectile, targetEnt)
        -- TODO: Buff unit here
    end
}


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
