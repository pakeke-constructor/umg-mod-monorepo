

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




dimensionControllerGroup:onAdded(function(ent)
    assert(ent.dimensionController, "wot wot?")
    dimensionToControllerEnt[ent.dimensionController] = ent
    controllerEntToDimension[ent] = ent.dimensionController
end)



local createDimTc = typecheck.assert("string", "table?")


function dimensions.createDimension(dimension, ent_or_nil)
    createDimTc(dimension, ent_or_nil)
    if dimensionToControllerEnt[dimension] then
        -- what do we do? error?
    end

    -- create a dimension handler entity if one wasn't passed in
    local ent = ent_or_nil or server.entities.dimension_controller()
    -- Set the dimension

    ent.dimensionController = dimension
    dimensionToControllerEnt[dimension] = dimension
    umg.call("dimensions:dimensionCreated", dimension, ent)
    return ent
end



function dimensions.destroyDimension(dimension)

end



function dimensions.getController(dim)
    -- gets the controller entity for a dimension.
    -- If the dimension doesn't exist, nil is returned.
    return dimensionToControllerEnt[dim]
end




function dimensions.getAllDimensionControllers()
    return dimensionControllerGroup
end



if server then
    -- create the default dimension on start-up
    umg.on("@createWorld", function()
        dimensions.createDimension(constants.DEFAULT_DIMENSION)
    end)
end


return dimensions
