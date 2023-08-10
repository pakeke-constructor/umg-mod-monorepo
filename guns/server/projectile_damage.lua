



umg.on("physics:collide", function(projEnt, targetEnt, contact)
    if projEnt.projectile then
        if targetEnt.health then
            local damage = 0

            if projEnt.damage then
                mortality.server.damage(targetEnt, projEnt)
            end
        end
    end
end)

