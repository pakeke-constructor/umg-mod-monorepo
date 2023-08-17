

require("dimensions_events")


local getDimension = require("shared.get_dimension")
local constants = require("shared.constants")




local dimensions = {}



local dimensionSet = objects.Set()




local entToDimension = {--[[
    keeps track of what dimension entities are in.

    [ ent ] -> dimension
]]}





local strTc = typecheck.assert("string")

function dimensions.createDimension(dim)
    -- creates a dimension (if it doesnt exist)
    strTc(dim)
    if not dimensionSet:has(dim) then
        dimensionSet:add(dim)
        umg.call("dimensions:dimensionCreated", dim)
    end
end


function dimensions.destroyDimension(dim)
    -- destroys a dimension (if it exists)
    strTc(dim)
    if dimensionSet:has(dim) then
        dimensionSet:remove(dim)
        umg.call("dimensions:dimensionDestroyed", dim)
    end
end


function dimensions.exists(dim)
    return dimensionSet:has(dim)
end




local dimensionGroup = umg.group("dimension")


dimensionGroup:onAdded(function(ent)
    local dim = getDimension(ent)
    entToDimension[ent] = dim
end)


dimensionGroup:onRemoved(function(ent)
    entToDimension[ent] = nil
end)




local function updateEnt(ent)
    --[[
        checks if the entity has changed dimensions.
        if so, emit a `entityMoved` callback.

        This allows any code on server-side to change dimensions on the fly,
        and have no weird issues.
    ]]
    local dim = getDimension(ent)
    local oldDim = getDimension(entToDimension[ent])
    if oldDim ~= dim then
        local newDim = dim
        if dimensions.exists(newDim) then
            entToDimension[ent] = newDim
            umg.call("dimensions:entityMoved", ent, oldDim, newDim)
        else
            -- if the new dimension doesn't exist,
            -- emit an event telling the system that an entity tried to move into void.
            umg.call("dimensions:entityMoveFailed", ent, oldDim, newDim)
        end
    end
end



if server then

umg.on("@tick", function()
    for i=1, #dimensionGroup do
        local ent = dimensionGroup[i]
        updateEnt(ent)
    end
end)

end




if server then
    -- create the default dimension on start-up
    umg.on("@createWorld", function()
        dimensions.createDimension(constants.DEFAULT_DIMENSION)
    end)
end


return dimensions
