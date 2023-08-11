

return {
    testMoveToPlayer = true,
    draw = true,

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
        shape = love.physics.newCircleShape(5);
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

    init = base.initializers.initXY
}

