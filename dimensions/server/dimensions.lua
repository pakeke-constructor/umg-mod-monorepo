

require("dimensions_events")


local getDimension = require("shared.get_dimension")


local dimensions = {}




local dimensionToEntityCount = {--[[
    keeps track of how many entities per dimension.
    If there are 0 entities, the dimension is culled.

    [ dimensionName ] -> count
]]}



local entToDimension = {--[[
    keeps track of what dimension entities are in.

    [ ent ] -> dimension
]]}




--[[
    with the dimensions mod loaded,
    ALL entities are emplaced into a dimension.
]]
local dimensionGroup = umg.group() --  <<< this is the all group.



local function createDimension(dim)
    assert(not dimensionToEntityCount[dim], "this is the police")
    dimensionToEntityCount[dim] = 0
    umg.call("dimensions:dimensionCreated", dim)
end



local function removeFromDimension(ent)
    local dim = entToDimension[ent]
    if dim then
        -- ensures that removing twice doesn't break stuff
        dimensionToEntityCount[dim] = dimensionToEntityCount[dim] - 1
        entToDimension[ent] = nil
    end

    if dimensionToEntityCount[ent] <= 0 then
        -- dimensions are culled if there are no entities inside it
        umg.call("dimensions:dimensionDestroyed")
    end
end



local function addToDimension(ent, dim)
    entToDimension[ent] = dim
    if not dimensionToEntityCount[dim] then
        createDimension(dim)
    end
    dimensionToEntityCount[dim] = dimensionToEntityCount[dim] + 1
end



dimensionGroup:onAdded(function(ent)
    local dim = getDimension(ent)
    addToDimension(ent, dim)
end)


dimensionGroup:onRemoved(function(ent)
    removeFromDimension(ent)
end)







local function updateEnt(ent)
    --[[
        checks if the entity has changed dimensions.
        if so, emit a `entityMoved` callback.

        This allows any code on server-side to change dimensions on the fly,
        and have no weird issues.
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

