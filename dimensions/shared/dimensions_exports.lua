

local getDimension = require("shared.get_dimension")


local dimensions = {}


dimensions.getDimension = getDimension


local dimensionSet = objects.Set()

umg.on("dimensions:dimensionCreated", function(dim)
    dimensionSet:add(dim)
end)

umg.on("dimensions:dimensionDestroyed", function(dim)
    dimensionSet:remove(dim)
end)



function dimensions.getAllDimensions()
    return dimensionSet
end



function dimensions.exists(dim)
    return dimensionSet:has(dim)
end



local DimVector = require("shared.dimension_vector")

dimensions.DimensionVector = DimVector.DimensionVector
dimensions.isDimensionVector = DimVector.isDimensionVector


--[[
    generates a unique dimension name based off of `name`.
    For example:
    generateUniqueDimension("house") --> "house_238934985458"

    returned dimension is guaranteed to be unique.
]]
local MAX_ITER = 10000
local MAX_NUMBER = 2^30
local GEN_SEP = "_"

function dimensions.generateUniqueDimension(name)
    if not dimensions.exists(name) then
        -- if there are no dimensions called `name`, then we can just use name
        return name
    end

    -- else, generate a new one by appending big random number
    local i = 0
    while i < MAX_ITER do
        local num = love.math.random(MAX_NUMBER)
        local dim = name .. GEN_SEP .. tostring(num)
        if not dimensions.exists(dim) then
            return dim
        end
    end
end




local DEFAULT_DIMENSION = require("shared.constants").DEFAULT_DIMENSION

function dimensions.getDefaultDimension()
    return DEFAULT_DIMENSION
end


umg.expose("dimensions", dimensions)

return dimensions

