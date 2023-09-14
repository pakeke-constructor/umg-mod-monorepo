

require("dimensions_events")


local constants = require("shared.constants")

local DEFAULT_DIMENSION = constants.DEFAULT_DIMENSION



local dimensions = {}



local overseeingDimensionGroup = umg.group("overseeingDimension")


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


overseeingDimensionGroup:onAdded(function(ent)
    assert(ent.overseeingDimension, "wot wot?")
    local dim = ent.overseeingDimension
    dimensionToControllerEnt[dim] = ent
    controllerEntToDimension[ent] = dim
    umg.call("dimensions:dimensionCreated", dim, ent)
end)


overseeingDimensionGroup:onRemoved(function(ent)
    if server and ent.overseeingDimension then
        destroyDimension(ent.overseeingDimension)
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
    ent.overseeingDimension = dimension

    dimensionToControllerEnt[dimension] = ent
    return ent
end



local strTc = typecheck.assert("string")

function dimensions.destroyDimension(dimension)
    strTc(dimension)
    local overseer = dimensions.getOverseer(dimension)
    if umg.exists(overseer) then
        overseer:deepDelete()
    end
end



function dimensions.getOverseer(dim)
    -- gets the controller entity for a dimension.
    -- If the dimension doesn't exist, nil is returned.
    dim = dim or DEFAULT_DIMENSION
    return dimensionToControllerEnt[dim]
end




function dimensions.getAllDimensions()
    local allDimensions = objects.Array()
    for _, dim in pairs(controllerEntToDimension) do
        allDimensions:add(dim)
    end
    return allDimensions
end


function dimensions.iterator()
    return pairs(dimensionToControllerEnt)
end



if server then
    -- create the default dimension on start-up
    umg.on("@createWorld", function()
        dimensions.createDimension(constants.DEFAULT_DIMENSION)
    end)
end


return dimensions
