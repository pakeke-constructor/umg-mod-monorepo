

local controllers = {}


local dimensionControllerGroup = umg.group("dimensionController")


local dimensionToControllerEnt = {--[[
    [dimension] -> controllerEnt
]]}


local controllerEntToDimension = {--[[
    [controllerEnt] -> dimension
]]}



dimensionControllerGroup:onAdded(function(ent)
    local dimension = ent.dimensionController
    if type(dimension) ~= "string" then
        error("Dimension names must be strings!")
    end
    if dimensionToControllerEnt[dimension] then
        error("Dimension already existed: " .. tostring(dimension))
    end
    dimensionToControllerEnt[dimension] = ent
    controllerEntToDimension[ent] = dimension
end)



function controllers.newDimension(dimensionName, ent_or_nil)
    -- create a dimension handler entity if one wasn't passed in
    local ent = ent_or_nil or server.entities.dimension_controller()
    -- Set the dimension
    ent.dimensionController = dimensionName
end



return controllers
