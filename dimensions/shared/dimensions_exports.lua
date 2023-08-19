
require("dimensions_events")
local getDimension = require("shared.get_dimension")

local api = require("shared.dimensions")


local dimensions = {}


dimensions.getDimension = getDimension


dimensions.getOverseer = api.getOverseer

dimensions.getAllDimensions = api.getAllDimensions
dimensions.iterator = api.iterator



local type = type
local function exists(dim)
    if type(dim) ~= "string" then
        return false, "expected dimension"
    end
    if not dimensions.getOverseer(dim) then
        return false, "expected dimension"
    end
    return true
end

typecheck.addType("dimension", exists)


dimensions.DimensionVector = require("shared.dimension_vector")
dimensions.DimensionPartition = require("shared.dimension_partition")
dimensions.DimensionStructure = require("shared.dimension_structure")


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


if server then
--[[
    creating / destroying is only available on server
]]
dimensions.server = {}

dimensions.server.createDimension = api.createDimension
dimensions.server.destroyDimension = api.destroyDimension

end



local DEFAULT_DIMENSION = require("shared.constants").DEFAULT_DIMENSION

function dimensions.getDefaultDimension()
    return DEFAULT_DIMENSION
end


umg.expose("dimensions", dimensions)

return dimensions

