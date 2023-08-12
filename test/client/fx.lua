


umg.on("mortality:entityDeath", function(ent)
    if ent.deathSound then
        local eds = ent.deathSound
        local name, vol = eds.name, eds.vol
        sound.playSound(name, vol)
    end

    if ent.deathParticles then
        local name, amount = ent.deathParticles.name, ent.deathParticles.amount
        visualfx.particles.emit(name, ent.x, ent.y, ent.z, amount)
    end
end)


umg.on("items:useItem", function(holderEnt, item, ...)
    if item.projectileLauncher then
        sound.playSound("pew_main3", 0.6)
    end
end)


