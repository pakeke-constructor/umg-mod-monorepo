
--[[

Handles entities changing dimensions

]]


local getDimension = require("shared.get_dimension")



local entToDimension = {--[[
    keeps track of what dimension entities are in.

    [ ent ] -> dimension
]]}




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
        if dimensions.getController(newDim) then
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

