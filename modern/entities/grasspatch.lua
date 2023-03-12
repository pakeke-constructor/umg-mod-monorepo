


return {
    grid = {
        width = 16,
        height = 16
    },

    --[[
        TODO:
        There should be a function to generate this.
    ]]
    imageTiling = {
        {
            image = "grasspatch_solo",
            layout = {
                {".",".","."},
                {".","X","."},
                {".",".","."},
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
            image = "grasspatch_topleft_fill",
            layout = {
                {".","#","#"},
                {"#","X","#"},
                {"#","#","#"},
            },
            canRotate = true
        },
        {
            image = "grasspatch_topleft_empty",
            layout = {
                {".",".","?"},
                {".","X","#"},
                {"?","#","#"},
            },
            canRotate = true
        },
        {
            image = "grasspatch_right",
            layout = {
                {"#","#","?"},
                {"#","X","."},
                {"#","#","?"},
            },
            priority = 1,
            canFlipHorizontal = true
        },
        {
            image = "grasspatch_top",
            layout = {
                {"?",".","?"},
                {"#","X","#"},
                {"#","#","#"},
            },
            canFlipVertical = true
        }
    },

    init = base.entityHelper.initPosition
}


