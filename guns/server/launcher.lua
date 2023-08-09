
require("guns_questions")


local launcher = {}



local function getProjectileCount(item, holderEnt, ...)
    -- assumes `item` has `projectileLauncher` component
    local plauncher = item.projectileLauncher

    return plauncher.count
end




local function getProjectileType(item, holderEnt, ...)
    -- assumes `item` has `projectileLauncher` component
    local plauncher = item.projectileLauncher

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

local function getProjectileSpeed(item, projectileEnt, holderEnt)
    -- assumes `item` has `projectileLauncher` component
    local plauncher = item.projectileLauncher

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

local function getProjectileInaccuracy(item, projectileEnt, holderEnt)
    local plauncher = item.projectileLauncher

    local accuracyMod = umg.ask("guns:getProjectileInaccuracy", item, projectileEnt, holderEnt) or 0

    if plauncher.projectileSpeed then
        return plauncher.projectileSpeed + accuracyMod
    end

    return DEFAULT_ACCURACY + accuracyMod
end




local DEFAULT_SPREAD = math.pi / 4

local function getProjectileSpread(item, projectileEnt, holderEnt)
    local plauncher = item.projectileLauncher
    assert(plauncher, "no projectileLauncher..?")

    local spreadMod = umg.ask("guns:getProjectileSpread", item, projectileEnt, holderEnt) or 0

    if plauncher.spread then
        return plauncher.spread + spreadMod
    end

    return DEFAULT_SPREAD + spreadMod
end







local function spawnProjectileEntity(item, holderEnt, ...)
    --[[
        this function may return nil!!!
    ]]
    -- spawns a projectile entity (bullet.) Does not set position or anything.
    local type = launcher.getProjectileType(item, holderEnt, ...)

    local ent
    if holderEnt.spawnProjectile then
        ent = holderEnt.spawnProjectile(holderEnt, item)
        if ent then
            return ent
        end
    end

    local etype = launcher.getProjectileType(item, holderEnt)
    if server.entities[etype] then
        ent = server.entities[etype]()
    end

    return ent
end



local function setupProjectile(item, projectileEnt, holderEnt, i)
    local speed = getProjectileSpeed(item, projectileEnt, holderEnt)
    local inaccuracy = getProjectileInaccuracy(item, projectileEnt, holderEnt)
    local spread = getProjectileSpread(item, projectileEnt, holderEnt)
end



function launcher.launchProjectile(item, holderEnt, ...)
    assert(server, "wot wot")
    assert(type(item.projectileLauncher) == "table", "wot wot???")

    local num_to_shoot = getProjectileCount(item, holderEnt, ...)

    for i=1, num_to_shoot do
        local projEnt = spawnProjectileEntity(item, holderEnt, ...)
        if projEnt then
            setupProjectile(item, projEnt, holderEnt, i)
        end
    end

end




function launchProjectileClient(holderEnt, item, ...)

end







return launcher

