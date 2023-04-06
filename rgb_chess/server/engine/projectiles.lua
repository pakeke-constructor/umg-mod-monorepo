

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


umg.on("rgbProjectileHit", function(projectileSource, targetEnt)
    hitHandlers[projectileSource.projectileType](projectileSource, targetEnt)
end)

