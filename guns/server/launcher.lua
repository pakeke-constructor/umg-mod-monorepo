

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




local DEFAULT_PROJECTILE_SPEED = 300 -- this seems reasonable

function launcher.getProjectileSpeed(item, projectileEnt, holderEnt)
    --[[
        assumes `item` has `projectileLauncher` component
    ]]
    local plauncher = item.projectileLauncher
    assert(plauncher, "no projectileLauncher..?")

    local projSpeed = umg.ask("guns:getProjectileSpeed", item, projectileEnt, holderEnt)
    if projSpeed then
        return projSpeed
    end

    if plauncher.projectileSpeed then
        return plauncher.projectileSpeed
    end

    if projectileEnt.speed then
        return projectileEnt.speed
    end

    return DEFAULT_PROJECTILE_SPEED
end



return launcher

