
require("guns_questions")


local launcher = {}



function launcher.getProjectileType(item, holderEnt, ...)
    -- assumes `item` has `projectileLauncher` component
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
    -- assumes `item` has `projectileLauncher` component
    local plauncher = item.projectileLauncher
    assert(plauncher, "no projectileLauncher..?")

    local speedMod = umg.ask("guns:getProjectileSpeed", item, projectileEnt, holderEnt) or 0

    if plauncher.projectileSpeed then
        return plauncher.projectileSpeed + speedMod
    end

    if projectileEnt.speed then
        return projectileEnt.speed + speedMod
    end

    return DEFAULT_PROJECTILE_SPEED + speedMod
end





local DEFAULT_ACCURACY = 0

function launcher.getProjectileAccuracy(item, projectileEnt, holderEnt)
    local plauncher = item.projectileLauncher
    assert(plauncher, "no projectileLauncher..?")

    local accuracyMod = umg.ask("guns:getProjectileAccuracy", item, projectileEnt, holderEnt) or 0

    if plauncher.projectileSpeed then
        return plauncher.projectileSpeed + accuracyMod
    end

    return DEFAULT_ACCURACY + accuracyMod
end



return launcher

