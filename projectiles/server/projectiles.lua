

local projectileGroup = umg.group("projectile")


--[[

projectiles should decay over time.

We don't want proj entities existing "forever", because that
would be dumb, AND it would put strain on the engine.

Proposal:
Every `projectile` entity is given a `lifetime` value.
(A default value is given if none provided)


]]
local function assertOk(ent)
    local proj = ent.projectile
    if type(proj) ~= "table" then
        error(".projectile component needs to be a table. Not the case for: " .. tostring(ent:type()))
    end
end


local DEFAULT_LIFETIME = 5

local LONG_TIME = 0xffffffffff -- >500 years in seconds


projectileGroup:onAdded(function(ent)
    assertOk(ent)
    local lifetime = ent.projectile.lifetime or DEFAULT_LIFETIME
    if lifetime < LONG_TIME then
        -- this check is for efficiency reasons.
        -- Any time longer than this, and we shouldnt bother adding .lifetime
        ent.lifetime = lifetime
    end
end)










--[[

For collisions:
There are still a few unsupported features.

We need:
- piercing projectiles 
    - (i.e. projectile aren't deleted instantly)
- projectile collisions not through the physics system
    - (i.e. proj impact occurs when gets in range of a specific entity)

]]

local function hit(projEnt, targetEnt)
    if targetEnt.health then
        local dmg = 0
        if projEnt.projectile.damage then
            dmg = projEnt.projectile.damage
        end
        -- TODO: Do extra stuff here!!!
        -- We need a question for damage modifiers!
        if dmg > 0 then
            mortality.server.damage(targetEnt, dmg)
        end
    end

    umg.call("projectiles:hit", projEnt, targetEnt)

    mortality.server.kill(projEnt)
end



umg.on("physics:collide", function(projEnt, targetEnt, contact)
    if projEnt.projectile then
        hit(projEnt, targetEnt)
    end
end)


