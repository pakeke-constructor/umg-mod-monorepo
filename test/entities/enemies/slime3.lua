
return {
    testMoveToPlayer = true,
    draw = true,
    slime = true,

    spawnOnDeath = {
        {type = "slime", chance = 1, count = 1},
        {type = "slime3", chance = 0.15, count = 2},
        {type = "slime2", chance = 1, count = 1},
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
        size = 7,
        oy = 8
    },

    healthBar = {
        offset = 14,
        drawWidth = 16,
        color = {0.7,0,0}
    },

    controllable = {
        movement = true
    };

    maxHealth = 70,

    physics = {
        shape = love.physics.newCircleShape(6);
        friction = 7
    },

    animation = {
        frames = {
            "slime5_000",
            "slime5_001",
            "slime5_002",
            "slime5_003",
            "slime5_004",
            "slime5_005",
            "slime5_006",
            "slime5_007",
            "slime5_008",
        },
        speed = 0.6
    },

    init = base.initializers.initXY
}

