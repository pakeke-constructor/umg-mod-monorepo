

local borders = {}


local WHITE = {1,1,1,1}




function checkBorder(options)
    local border = {}

    assert(options.centerX, "borders need centerX")
    assert(options.centerY, "borders need centerY")
    assert(options.width, "borders need width")
    assert(options.height, "borders need height")

    border.color = options.color or WHITE
    border.centerX = options.centerX
    border.centerY = options.centerY
    border.x = options.centerX - options.width / 2
    border.y = options.centerY - options.height / 2
    border.width = options.width
    border.height = options.height
    
    return border
end




local setBorderTc = typecheck.assert("dimension", "table")


function borders.setBorder(dimension, options)
    setBorderTc(dimension, options)
    
    local overseerEnt = dimensions.getOverseer(dimension)
    overseerEnt.border = checkBorder(options)
end


umg.expose("borders", borders)
return borders

