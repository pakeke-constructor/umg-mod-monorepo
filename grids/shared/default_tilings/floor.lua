
local common = require("shared.default_tilings.common")



local function newFloorTiling(args)
    local imageTiling = {}

    local it = imageTiling --alias

    common.add(args, "isolated", it, {
        layout = {
            {"?","?","?"},
            {"?","X","?"},
            {"?","?","?"},
        },
        priority = -5
    })

    common.add(args, "fill", it, {
        layout = {
            {"#","#","#"},
            {"#","X","#"},
            {"#","#","#"},
        },
        priority = 5
    })

    common.add(args, "fill", it,{
        layout = {
            {"#","#","?"},
            {"#","X","#"},
            {"?","#","#"},
        },
        priority = 0,
        canFlipHorizontal = true
    })

    common.add(args, "topleftFill", it, {
        layout = {
            {".","#","#"},
            {"#","X","#"},
            {"#","#","#"},
        },
        priority = 4,
        canRotate = true
    })

    common.add(args, "topleftEmpty", it, {
        layout = {
            {"?","?","?"},
            {"?","X","#"},
            {"?","#","#"},
        },
        priority = -1,
        canRotate = true
    })

    common.add(args, "left", it, {
        image = args.left,
        layout = {
            {"#","#","?"},
            {"#","X","?"},
            {"#","#","?"},
        },
        priority = 1,
        canFlipHorizontal = true
    })
      
    common.add(args, "top", it, {
        image = args.top,
        layout = {
            {"?","?","?"},
            {"#","X","#"},
            {"#","#","#"},
        },
        priority = 1,
        canFlipVertical = true
    })

    return imageTiling
end


return newFloorTiling

