
local common = require("shared.default_tilings.common")



local function newFenceTiling(args)
    local imageTiling = {}
    local it = imageTiling --alias

    common.add(args, "isolated", it, {
        layout = {
            {"?","?","?"},
            {"?","X","?"},
            {"?","?","?"},
        },
        priority = -1
    })

    common.add(args, "vertical", it, {
        layout = {
            {".","#","."},
            {".","X","."},
            {".","#","."},
        },
        priority = 1
    })

    common.add(args, "horizontal", it,{
        layout = {
            {".",".","."},
            {"#","X","#"},
            {".",".","."},
        },
        priority = 1
    })

    common.add(args, "topDiagonal", it, {
        layout = {
            {".",".","."},
            {".","X","#"},
            {".","#","."},
        },
        priority = 1,
        canFlipHorizontal = true
    })
    
    common.add(args, "bottomDiagonal", it, {
        layout = {
            {".","#","."},
            {".","X","#"},
            {".",".","."},
        },
        priority = 1,
        canFlipHorizontal = true
    })

    return imageTiling
end



return newFenceTiling
