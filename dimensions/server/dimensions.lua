

local getDimension = require("shared.get_dimension")




local entToDimension = {--[[
    keeps track of what dimension entities are in.

    [ ent ] -> dimension
]]}




--[[
    in the dimensions mod, ALL entities belong in a dimension.
]]
local dimensionGroup = umg.group()



dimensionGroup:onAdded(function(ent)
    local dim = getDimension(ent)
    entToDimension[ent] = dim

end)


dimensionGroup:onRemoved(function(ent)
    entToDimension[ent] = nil
end)




if server then


local function updateEnt(ent)
    --[[
        checks if the entity has changed dimensions.
        if so, emit a `entityMoved` callback.

        This allows the server-side to change dimensions on the fly,
        and have no repercussions.
    ]]
    local dim = getDimension(ent)
    if entToDimension[ent] ~= dim then
        local oldDim = entToDimension[ent]
        local newDim = dim
        entToDimension[ent] = dim
        umg.call("dimensions:entityMoved", ent, oldDim, newDim)
    end
end



umg.on("@tick", function()
    for _, ent in ipairs(dimensionGroup) do
        updateEnt(ent)
    end
end)


end
