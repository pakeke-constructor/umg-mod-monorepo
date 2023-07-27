

local function done(projectileEnt)
    -- called when a projectile is done it's journey
    -- TODO: Maybe offload sfx or something?
    mortality.server.kill(projectileEnt)
end




local projectileGroup = umg.group("rgbProjectile")


local PROJECTILE_STOP_DIST = 4


projectileGroup:onAdded(function(projEnt)
    assert(projEnt.rgbProjectileOnHit, "needs a rgbProjectileOnHit callback")
end)


umg.on("@tick", function()
    --[[
        check for projectiles whose target has been deleted.
        If the target no longer exists, mark projectile as done.
    ]]
    for _, ent in ipairs(projectileGroup) do
        local targetEnt = ent.targetEntity
        if not umg.exists(targetEnt) then
            done(ent)
        else
            if math.distance(ent, targetEnt) <= PROJECTILE_STOP_DIST then
                ent:rgbProjectileOnHit(targetEnt)
                done(ent)
            end
        end
    end
end)
