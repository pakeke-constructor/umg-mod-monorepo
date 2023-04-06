

local PROJTYPES = constants.PROJECTILE_TYPES

local hitHandlers = {
    [PROJTYPES.CUSTOM] = function(projectileSource, targetEnt)
        projectileSource:projectileOnHit(targetEnt)
    end,

    [PROJTYPES.DAMAGE] = function(projectileSource, targetEnt)
        attack.attack(projectileSource, targetEnt)  
    end,

    [PROJTYPES.HEAL] = function(projectileSource, targetEnt)
        -- TODO: Heal unit here        
    end,

    [PROJTYPES.SHIELD] = function(projectileSource, targetEnt)
        -- TODO: Shield unit here
    end,

    [PROJTYPES.BUFF] = function(projectileSource, targetEnt)
        -- TODO: Buff unit here
    end
}


umg.on("rgbProjectileHit", function(projectileSource, targetEnt)
    hitHandlers[projectileSource.projectileType](projectileSource, targetEnt)
end)

