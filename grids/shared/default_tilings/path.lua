

local common = require("shared.default_tilings.common")




local function generatePathTiling(args)
    if not client then
        return {} -- server doesn't care about this component
    end
    
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
            {"?","#","?"},
            {".","X","."},
            {"?","#","?"},
        },
        priority = 1
    })

    common.add(args, "horizontal", it,{
        layout = {
            {"?",".","?"},
            {"#","X","#"},
            {"?",".","?"},
        },
        priority = 1,
    })

    common.add(args, "diagonal", it, {
        layout = {
            {"?",".","?"},
            {".","X","#"},
            {"?","#","?"},
        },
        priority = 1,
        canRotate = true
    })

    return imageTiling
end


return generatePathTiling

