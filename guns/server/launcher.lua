

local launcher = {}



function launcher.getProjectileType(item, holderEnt, ...)
    --[[
        assumes `item` has `projectileLauncher` component
    ]]
    local plauncher = item.projectileLauncher
    assert(plauncher, "no projectileLauncher..?")

    local projType = umg.ask("guns:getProjectileType", holderEnt, item, ...)
    if projType then
        -- allow for override
        return projType
    end

    if plauncher.projectileType then
        return plauncher.projectileType
    end

    --[[
        TODO: do more exotic stuff here.
            Random projectile types...?
    ]]
    return nil -- nil implies there is no projectile to be shot.
end





function launcher.getProjectileSpeed(holderEnt, item, projectile)
    
end



return launcher

