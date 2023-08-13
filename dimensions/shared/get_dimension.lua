
local constants = require("shared.constants")


local DEFAULT_DIMENSION = constants.DEFAULT_DIMENSION


local function getDimension(ent)
    if type(ent) == "table" then
        return ent.dimension or DEFAULT_DIMENSION
    end
    -- else, it's prolly a dimension value
    return ent or DEFAULT_DIMENSION
end


return getDimension
