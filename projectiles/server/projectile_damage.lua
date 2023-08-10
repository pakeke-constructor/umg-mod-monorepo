


umg.on("physics:collide", function(projEnt, targetEnt, contact)
    if projEnt.projectile then
        if targetEnt.health then
            local damage = 0
            if projEnt.damage then
                damage = projEnt.damage
            end
            -- TODO: Do extra stuff here!!!
            -- We need a question for damage modifiers!
            if damage > 0 then
                mortality.server.damage(targetEnt, damage)
            end
        end

        umg.call("projectiles:projectileHit", projEnt, targetEnt)

        mortality.server.kill(projEnt)
    end
end)

