


return {
    grid = {
        width = 15,
        height = 15
    },

    drawDepth = -400,

    --[[
        TODO:
        There should be a function to generate this.
    ]]
    imageTiling = {
        {
            image = "grasspatch_solo",
            layout = {
                {"?","?","?"},
                {"?","X","?"},
                {"?","?","?"},
            },
            priority = -5
        },
        {
            image = "grasspatch_fill",
            layout = {
                {"#","#","#"},
                {"#","X","#"},
                {"#","#","#"},
            },
            priority = 5
        },
        {
            image = "grasspatch_fill",
            layout = {
                {"#","#","?"},
                {"#","X","#"},
                {"?","#","#"},
            },
            priority = 0,
            canFlipHorizontal = true
        },
        {
            image = "grasspatch_topleft_fill",
            layout = {
                {".","#","#"},
                {"#","X","#"},
                {"#","#","#"},
            },
            priority = 4,
            canRotate = true
        },
        {
            image = "grasspatch_topleft_empty",
            layout = {
                {"?","?","?"},
                {"?","X","#"},
                {"?","#","#"},
            },
            priority = -1,
            canRotate = true
        },
        {
            image = "grasspatch_right",
            layout = {
                {"#","#","?"},
                {"#","X","?"},
                {"#","#","?"},
            },
            priority = 1,
            canFlipHorizontal = true
        },
        {
            image = "grasspatch_top",
            layout = {
                {"?","?","?"},
                {"#","X","#"},
                {"#","#","#"},
            },
            priority = 1,
            canFlipVertical = true
        }
    },

    init = base.entityHelper.initPosition
}


