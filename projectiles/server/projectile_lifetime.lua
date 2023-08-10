
--[[

projectiles should decay over time.

We don't want proj entities existing "forever", because that
would be dumb, AND it would put strain on the engine.

Proposal:
Every `projectile` entity is given a `decay` value.
A sensible default could be like, 2 seconds, or something.



]]



local projectileGroup = umg.group("projectile")



local DEFAULT_LIFETIME = 5



local function assertOk(ent)
    local proj = ent.projectile
    if type(proj) ~= "table" then
        error(".projectile component needs to be a table. Not the case for: " .. tostring(ent:type()))
    end
end


projectileGroup:onAdded(function(ent)
    assertOk(ent)
    local lifetime = ent.projectile.lifetime or DEFAULT_LIFETIME
    ent.lifetime = lifetime
end)


