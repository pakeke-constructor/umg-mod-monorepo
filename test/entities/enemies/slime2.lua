
return {
    testMoveToPlayer = true,
    draw = true,
    slime = true,

    spawnOnDeath = {
        {type = "slime", chance = 1, count = 2},
        {type = "slime2", chance = 0.07, count = 2},
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
        size = 6,
        oy = 7
    },

    healthBar = {
        offset = 14,
        drawWidth = 16,
        color = {0.7,0,0}
    },

    maxHealth = 40,

    physics = {
        shape = love.physics.newCircleShape(5);
        friction = 7
    },

    animation = {
        frames = {
            "slime2_000",
            "slime2_001",
            "slime2_002",
            "slime2_003",
            "slime2_004",
            "slime2_005",
            "slime2_006",
            "slime2_007",
            "slime2_008",
        },
        speed = 0.6
    },

    init = base.initializers.initXY
}

