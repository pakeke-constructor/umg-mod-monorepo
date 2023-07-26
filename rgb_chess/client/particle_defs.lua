


local dustPsys = visualfx.particles.newParticleSystem({
    "smoke1", "smoke2", "smoke3", "smoke4"
})
dustPsys:setParticleLifetime(0.2,0.3)
dustPsys:setEmissionArea("uniform", 1, 1, 0)
visualfx.particles.define("dust", dustPsys)




local circlePsys = visualfx.particles.newParticleSystem({
    "circ4", "circ3", "circ2", "circ1"
})
circlePsys:setParticleLifetime(0.3,0.4)
visualfx.particles.define("circle", circlePsys)

