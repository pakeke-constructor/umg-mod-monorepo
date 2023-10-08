
--[[

projectiles should decay over time.

We don't want proj entities existing "forever", because that
would be dumb, AND it would put strain on the engine.

Proposal:
Every `projectile` entity is given a `lifetime` value.



]]



local projectileGroup = umg.group("projectile")



local function assertOk(ent)
    local proj = ent.projectile
    if type(proj) ~= "table" then
        error(".projectile component needs to be a table. Not the case for: " .. tostring(ent:type()))
    end
end


projectileGroup:onAdded(function(ent)
    assertOk(ent)
    local lifetime = ent.projectile.lifetime
    ent.lifetime = lifetime
end)


