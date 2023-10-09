
if client then
    local psys = juice.particles.newParticleSystem({
        "circ4", "circ3", "circ2", "circ1"
    })
    psys:setParticleLifetime(0.4,0.9)
    psys:setColors(
        0,1,0,1
    )
    psys:setEmissionRate(0) -- TODO: this doesn't FRICKEN work!!!!
    psys:setEmissionArea("uniform", 1, 1, 0)
    juice.particles.define("slime", psys)
end




return {
    testMoveToPlayer = true,
    drawable = true,
    slime = true,

    spawnOnDeath = {
        {type = "slime", chance = 0.13, count = 2}
    },

    deathParticles = {
        name = "slime",
        amount = 10
    },

    deathSound = {
        name = "splat1",
        vol = 0.5
    },

    shadow = {
        size = 4,
        oy = 6
    },

    healthBar = {
        offset = 14,
        drawWidth = 16,
        color = {0.7,0,0}
    },

    maxHealth = 10,

    physics = {
        shape = love.physics.newCircleShape(3);
        friction = 7
    },

    animation = {
        frames = {
            "slime1_000",
            "slime1_001",
            "slime1_002",
            "slime1_003",
            "slime1_004",
            "slime1_005",
            "slime1_006",
            "slime1_007",
            "slime1_008",
        },
        speed = 0.6
    },

    initXY = true
}

