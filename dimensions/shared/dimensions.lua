

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
        entToDimension[ent] = dim
        umg.call("dimensions:entityMoved", ent, oldDim, newDim)
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




--[[
    Syncing dimensions between client <--> server upon player join
]]
if server then

umg.on("@playerJoin", function(clientId)
    local buf = {}
    for _, dim in ipairs(dimensionSet) do
        table.insert(buf, dim)
    end
    server.unicast(clientId, "dimensions:setDimensions", buf)
end)

else

client.on("dimensions:setDimensions", function(buf)
    for _, dim in ipairs(buf) do
        dimensions.createDimension(dim)
    end
end)

end




umg.on("@load", function()
    dimensions.createDimension(constants.DEFAULT_DIMENSION)
end)

