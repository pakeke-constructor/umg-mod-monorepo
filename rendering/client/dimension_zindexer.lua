

local ZIndexer = require("client.zindexer")

--[[
to understand this class,
you'll first must understand DimensionObject in the dimensions mod.
]]
local DimensionZIndexer = objects.Class("rendering:DimensionZIndexer", dimensions.DimensionObject)




function DimensionZIndexer:init()
    self:super()
end


-- OVERRIDES:
function DimensionZIndexer:addEntityToObject(zindexer, ent)
    zindexer:addEntity(ent)
end

function DimensionZIndexer:removeEntityFromObject(zindexer, ent)
    zindexer:removeEntity(ent)
end

function DimensionZIndexer:newObject()
    return ZIndexer()
end
-- END OF OVERRIDES.


return DimensionZIndexer
