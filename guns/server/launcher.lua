
require("guns_questions")


local launcher = {}



local function getProjectileCount(item, holderEnt, ...)
    -- assumes `item` has `projectileLauncher` component
    local plauncher = item.projectileLauncher

    --[[
        TODO: Do more complex stuff here,
        like a question bus..?
    ]]
    if plauncher and plauncher.count then
        return plauncher.count
    end
    return 1 -- default is 1.
end




local function getProjectileType(item, holderEnt, ...)
    -- assumes `item` has `projectileLauncher` component
    local projType = umg.ask("guns:getProjectileType", holderEnt, item, ...)
    if projType then
        -- allow for override
        return projType
    end

    local plauncher = item.projectileLauncher
    if plauncher and plauncher.projectileType then
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
    local speedMod = umg.ask("guns:getProjectileSpeed", item, projectileEnt, holderEnt) or 0

    local plauncher = item.projectileLauncher
    if plauncher and plauncher.projectileSpeed then
        return plauncher.projectileSpeed + speedMod
    end

    if projectileEnt.speed then
        return projectileEnt.speed + speedMod
    end

    return DEFAULT_PROJECTILE_SPEED + speedMod
end





local DEFAULT_ACCURACY = 0

local function getProjectileInaccuracy(item, projectileEnt, holderEnt)
    local inaccuracyMod = umg.ask("guns:getProjectileInaccuracy", item, projectileEnt, holderEnt) or 0

    local plauncher = item.projectileLauncher
    if plauncher and plauncher.inaccuracy then
        return plauncher.inaccuracy + inaccuracyMod
    end

    return DEFAULT_ACCURACY + inaccuracyMod
end




local DEFAULT_SPREAD = math.pi / 4

-- spread shouldn't be bigger than 180 degrees.
-- that... would be dumb
local MAX_SPREAD = math.pi



local function getProjectileSpread(item, projectileEnt, holderEnt)
    local spreadMod = umg.ask("guns:getProjectileSpread", item, projectileEnt, holderEnt) or 0

    local plauncher = item.projectileLauncher
    if plauncher and plauncher.spread then
        if plauncher.spread > MAX_SPREAD then
            error("radian spread too big for entity: " .. tostring(item))
        end
        return plauncher.spread + spreadMod
    end

    return DEFAULT_SPREAD + spreadMod
end







local function spawnProjectileEntity(item, holderEnt, ...)
    --[[
        this function may return nil!!!
    ]]
    -- spawns a projectile entity (bullet.) Does not set position or anything.
    local ent
    if holderEnt.spawnProjectile then
        ent = holderEnt.spawnProjectile(holderEnt, item)
        if ent then
            return ent
        end
    end

    local etype = getProjectileType(item, holderEnt)
    if server.entities[etype] then
        ent = server.entities[etype]()
    end

    return ent
end



local DEFAULT_START_DISTANCE = 30

local function getStartDistance(item, holderEnt)
    return item.projectileLauncher.startDistance or DEFAULT_START_DISTANCE
end





local random = love.math.random
local sin, cos = math.sin, math.cos


local function setupProjectile(item, projEnt, holderEnt, spreadFactor)
    local speed = getProjectileSpeed(item, projEnt, holderEnt)
    local inaccuracy = getProjectileInaccuracy(item, projEnt, holderEnt)
    local spread = getProjectileSpread(item, projEnt, holderEnt)

    local startDistance = getStartDistance(item, holderEnt)

    local dx,dy = holderEnt.lookX - holderEnt.x, holderEnt.lookY - holderEnt.y
    local mag = math.distance(dx,dy)
    if mag ~= 0 then
        dx = dx/mag; dy=dy/mag
    end

    projEnt.x, projEnt.y = holderEnt.x + dx*startDistance, holderEnt.y + dy*startDistance

    local inaccuracyAngle = (random()-0.5) * inaccuracy
    local spreadAngle = spreadFactor * spread
    -- angle shift of direction of bullet
    local angle = inaccuracyAngle + spreadAngle

    -- shift by angle:
    local dx2 = dx*cos(angle) - dy*sin(angle)
    local dy2 = dx*sin(angle) + dy*cos(angle)

    -- amplify by speed:
    projEnt.vx = dx2 * speed
    projEnt.vy = dy2 * speed     
end




function launcher.useItem(item, holderEnt, ...)
    assert(server, "not on server")
    assert(type(item.projectileLauncher) == "table", "wot wot???")

    local num_to_shoot = getProjectileCount(item, holderEnt, ...)

    for i=0, num_to_shoot-1 do
        local projEnt = spawnProjectileEntity(item, holderEnt, ...)
        if projEnt then
            -- spreadFactor = number from -0.5 to 0.5 that represents
            -- the current "spread" of the bullet.
            local spreadFactor = (i / (num_to_shoot-1)) - 0.5
            setupProjectile(item, projEnt, holderEnt, spreadFactor)
        end
    end
end



local launchProjectileTc = typecheck.assert("entity", "entity", "entity")

function launcher.launchProjectile(item, projEnt, holderEnt)
    launchProjectileTc(item, projEnt, holderEnt)
    assert(server, "not on server")
    --[[
        launches a projectile from an item entity in a 
    ]]
    -- spreadFactor is 0 by default.
    setupProjectile(item, projEnt, holderEnt, 0)
end


return launcher

