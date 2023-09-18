
require("projectiles_questions")
require("projectiles_events")


local api = {}



local function getProjectileCount(item, holderEnt, shooter)
    --[[
        Returns the number of projectiles that should be shot
    ]]

    --[[
        TODO: Do more complex stuff here,
        like a question bus..?
    ]]
    if shooter and shooter.count then
        return shooter.count
    end
    return 1 -- default is 1.
end




local function getProjectileType(item, holderEnt, shooter)
    local projType = umg.ask("projectiles:getProjectileType", holderEnt, item)
    if projType then
        -- allow for override
        return projType
    end

    if shooter and shooter.projectileType then
        return shooter.projectileType
    end

    --[[
        TODO: do more exotic stuff here.
            Random projectile types...?
    ]]
    return nil -- nil implies there is no projectile to be shot.
end




local DEFAULT_PROJECTILE_SPEED = 300 -- this seems reasonable

local function getProjectileSpeed(item, projectileEnt, holderEnt, shooter)
    local speedMod = umg.ask("projectiles:getProjectileSpeed", item, projectileEnt, holderEnt) or 0

    if shooter and shooter.projectileSpeed then
        return shooter.projectileSpeed + speedMod
    end

    if projectileEnt.speed then
        return projectileEnt.speed + speedMod
    end

    return DEFAULT_PROJECTILE_SPEED + speedMod
end





local DEFAULT_ACCURACY = 0

local function getProjectileInaccuracy(item, projectileEnt, holderEnt, shooter)
    local inaccuracyMod = umg.ask("projectiles:getProjectileInaccuracy", item, projectileEnt, holderEnt) or 0

    if shooter.inaccuracy then
        return shooter.inaccuracy + inaccuracyMod
    end

    return DEFAULT_ACCURACY + inaccuracyMod
end




local DEFAULT_SPREAD = math.pi / 4

-- spread shouldn't be bigger than 180 degrees.
-- that... would be dumb
local MAX_SPREAD = math.pi



local function getProjectileSpread(item, projectileEnt, holderEnt, shooter)
    local spreadMod = umg.ask("projectiles:getProjectileSpread", item, projectileEnt, holderEnt) or 0

    if shooter.spread then
        return math.min(MAX_SPREAD, shooter.spread + spreadMod)
    end

    return DEFAULT_SPREAD + spreadMod
end







local function spawnProjectileEntity(item, holderEnt, shooter)
    --[[
        this function may return nil!!!
    ]]
    -- spawns a projectile entity (bullet.) Does not set position or anything.
    local ent
    if shooter.spawnProjectile then
        ent = shooter.spawnProjectile(item, holderEnt, shooter)
        if ent then
            return ent
        end
    end

    local etype = getProjectileType(item, holderEnt, shooter)
    if server.entities[etype] then
        ent = server.entities[etype]()
    end

    return ent
end



local DEFAULT_START_DISTANCE = 30

local function getStartDistance(item, holderEnt)
    return item.shooter.startDistance or DEFAULT_START_DISTANCE
end





local random = love.math.random
local sin, cos = math.sin, math.cos


local function setupProjectile(item, projEnt, holderEnt, shooter, spreadFactor)
    local speed = getProjectileSpeed(item, projEnt, holderEnt, shooter)
    local inaccuracy = getProjectileInaccuracy(item, projEnt, holderEnt, shooter)
    local spread = getProjectileSpread(item, projEnt, holderEnt, shooter)

    local startDistance = getStartDistance(item, holderEnt)

    local dx,dy = holderEnt.lookX - holderEnt.x, holderEnt.lookY - holderEnt.y
    local mag = math.distance(dx,dy)
    if mag ~= 0 then
        dx = dx/mag; dy=dy/mag
    end

    projEnt.x, projEnt.y = holderEnt.x + dx*startDistance, holderEnt.y + dy*startDistance
    if holderEnt.dimension then
        projEnt.dimension = holderEnt.dimension
    end

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



local function launch(item, holderEnt, shooter, spreadFactor)
    local projEnt = spawnProjectileEntity(item, holderEnt, shooter)
    if projEnt then
        setupProjectile(item, projEnt, holderEnt, shooter, spreadFactor)
    end
end


local function shoot(holderEnt, item, shooter)
    local num_to_shoot = getProjectileCount(item, holderEnt, shooter)
    
    -- we need these checks here so that we don't get NaNs w/ div by 0.
    if num_to_shoot <= 0 then
        return
    end

    if num_to_shoot <= 1 then
        -- shoot one bullet.
        launch(item, holderEnt, shooter, 0)
        return
    end

    for i=0, num_to_shoot-1 do
        -- spreadFactor = number from -0.5 to 0.5 that represents
        -- the current "spread" of the bullet.
        local spreadFactor = (i / (num_to_shoot-1)) - 0.5
        launch(item, holderEnt, shooter, spreadFactor)
    end
end


return shoot
