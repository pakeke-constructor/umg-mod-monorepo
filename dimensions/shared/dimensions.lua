

require("dimensions_events")


local constants = require("shared.constants")




local dimensions = {}



local dimensionControllerGroup = umg.group("dimensionController")


local dimensionToControllerEnt = {--[[
    [dimension] -> controllerEnt
]]}


local controllerEntToDimension = {--[[
    [controllerEnt] -> dimension
]]}




local function destroyDimension(dimension)
    assert(server, "?")
    local ent = dimensionToControllerEnt[dimension]
    if ent then
        dimensionToControllerEnt[dimension] = nil
        controllerEntToDimension[ent] = nil
        umg.call("dimensions:dimensionDestroyed", dimension, ent)
        ent:delete()
    end
end


dimensionControllerGroup:onAdded(function(ent)
    assert(ent.dimensionController, "wot wot?")
    dimensionToControllerEnt[ent.dimensionController] = ent
    controllerEntToDimension[ent] = ent.dimensionController
end)


dimensionControllerGroup:onRemoved(function(ent)
    if server and ent.dimensionController then
        destroyDimension(ent.dimensionController)
    end
end)




local createDimTc = typecheck.assert("string", "table?")


function dimensions.createDimension(dimension, ent_or_nil)
    createDimTc(dimension, ent_or_nil)
    assert(server, "?")
    if dimensionToControllerEnt[dimension] then
        error("Duplicate dimension created: " .. tostring(dimension))
    end

    -- create a dimension handler entity if one wasn't passed in
    local ent = ent_or_nil or server.entities.dimension_controller()
    -- Set the dimension

    ent.dimensionController = dimension
    dimensionToControllerEnt[dimension] = ent
    umg.call("dimensions:dimensionCreated", dimension, ent)
    return ent
end



local strTc = typecheck.assert("string")

function dimensions.destroyDimension(dimension)
    strTc(dimension)
    destroyDimension(dimension)
end



function dimensions.getController(dim)
    -- gets the controller entity for a dimension.
    -- If the dimension doesn't exist, nil is returned.
    return dimensionToControllerEnt[dim]
end




function dimensions.getAllDimensions()
    local allDimensions = objects.Array()
    for _, dim in pairs(controllerEntToDimension) do
        allDimensions:add(dim)
    end
    return allDimensions
end



if server then
    -- create the default dimension on start-up
    umg.on("@createWorld", function()
        dimensions.createDimension(constants.DEFAULT_DIMENSION)
    end)
end


return dimensions
