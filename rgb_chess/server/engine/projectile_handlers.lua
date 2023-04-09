

local function done(projectileEnt)
    -- called when a projectile is done it's journey
    -- TODO: Maybe offload sfx or something?
    base.server.kill(projectileEnt)
end




local projectileGroup = umg.group("rgbProjectile")


local PROJECTILE_STOP_DIST = 4


local function checkHit(projectileEnt, targetEnt)
    if not umg.exists(projectileEnt.sourceEntity) then
        return
    end
    if math.distance(projectileEnt, targetEnt) <= PROJECTILE_STOP_DIST then
        projectileEnt:rgbProjectileHit(targetEnt)
        done(projectileEnt)
    end
end


projectileGroup:onAdded(function(projEnt)
    assert(projEnt.rgbProjectileHit, "needs a rgbProjectileHit callback")
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
            checkHit(ent, targetEnt)
        end
    end
end)
