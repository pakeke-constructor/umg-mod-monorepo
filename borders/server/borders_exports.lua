

local borders = {}



local setBorderTc = typecheck.assert("dimension", "table")


function borders.setBorder(dimension, options)
    setBorderTc(dimension, options)
    assert(options.centerX, "borders need centerX")
    assert(options.centerY, "borders need centerY")
    assert(options.width, "borders need width")
    assert(options.height, "borders need height")

    local overseerEnt = dimensions.getOverseer(dimension)
    overseerEnt.border = options
end


umg.expose("borders", borders)
return borders

