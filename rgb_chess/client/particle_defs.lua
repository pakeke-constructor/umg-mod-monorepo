

local dustPsys = base.particles.newParticleSystem({
    "smoke1", "smoke2", "smoke3", "smoke4"
})
dustPsys:setParticleLifetime(0.2,0.3)

base.particles.define("dust", dustPsys)


