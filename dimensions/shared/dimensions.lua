

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



local function tryMoveToDimension(ent, oldDim, newDim)
    -- tries to move an entity to a dimension.
    -- If this operation fails, returns false. Else true
    if dimensions.exists(newDim) then
        entToDimension[ent] = newDim
        umg.call("dimensions:entityMoved", ent, oldDim, newDim)
        return true
    end
end



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
        local success = tryMoveToDimension(ent, oldDim, newDim)
        if not success then
            -- if the new dimension doesn't exist,
            -- emit an event telling the system that an entity tried to move into void.
            umg.call("dimensions:entityMovedIntoVoid", ent, newDim, oldDim)
            -- try move again. (the dimension may exist now)
            --[[
                TODO: this may not work properly!
                the idea is to allow for the above callback to generate
                a dimension if needed,
                but if dimensions are represented as `dimensionController`
                entities, there will be one frame of buffering before
                the dimensionController actually exists....
                do some thinking!!!!
            ]]
            tryMoveToDimension(ent, oldDim, newDim)
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

else-- client:

client.on("dimensions:setDimensions", function(buf)
    for _, dim in ipairs(buf) do
        dimensions.createDimension(dim)
    end
end)

end




umg.on("@load", function()
    dimensions.createDimension(constants.DEFAULT_DIMENSION)
end)


return dimensions
