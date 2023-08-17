
local constants = require("shared.constants")


local DEFAULT_DIMENSION = constants.DEFAULT_DIMENSION
local type = type


local function getDimension(x)
    --[[
    Gets the proper dimension (as a string) from the input, x.

    if x is a table, then we return `x.dimension`, or the default dimension.
    If x is a string, then we assume that x is a dimension.
    If x is nil, then we return the default dimension.
    ]]
    if type(x) == "table" then
        return x.dimension or DEFAULT_DIMENSION
    end
    -- else, it's prolly a dimension value
    return x or DEFAULT_DIMENSION
end


return getDimension
