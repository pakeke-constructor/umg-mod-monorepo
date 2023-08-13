

-- this cant be changed.
-- if we allow for changing of default dimension, that opens a whole can o worms
local DEFAULT_DIMENSION = "overworld"


local function getDimension(ent)
    return ent.dimension or DEFAULT_DIMENSION
end


return getDimension
