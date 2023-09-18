
--[[

TODO:

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


