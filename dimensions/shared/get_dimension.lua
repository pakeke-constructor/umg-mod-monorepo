
local constants = require("shared.constants")


local DEFAULT_DIMENSION = constants.DEFAULT_DIMENSION


local function getDimension(ent)
    return ent.dimension or DEFAULT_DIMENSION
end


return getDimension
