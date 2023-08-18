
--[[

A DimensionObject is an abstract data structure that contains
other Objects for each dimension.


----------------------

EXAMPLES:

DimensionObject<ZIndexer> is used for rendering.
Each entity gets put inside a ZIndexer data structure, per dimension.

DimensionObject<Box2d_world> used for physics.
Each dimension gets allocated a box2d world.
Entities

]]

require("shared.dimension_vector") -- we need typecheck defs

local getDimension = require("shared.get_dimension")


local DimensionObject = objects.Class("dimensions:DimensionObject")




function DimensionObject:super()
    self.dimensionToObject = {--[[
        [dimension] --> Object
    ]]}

    self.entityToDimension = {--[[
        [entity] -> dimension
    ]]}
end



--[[
    gets the object owned by the following dimension.

    NOTE: 
    If you call `:getObject(ent.dimension)`, it is NOT
    guaranteed to return the object that contains this entity!!!!
    Use `getContainingObject` instead!!
]]
function DimensionObject:getObject(dimension)
    if self.dimensionToObject[dimension] then
        return self.dimensionToObject[dimension]
    end

    local partition = self:newObject(self.chunkSize)
    self.dimensionToObject[dimension] = partition
    return partition
end



--[[
    Gets the object that contains the given entity.
]] 
function DimensionObject:getObjectForEntity(ent)
    local dim = self.entityToDimension[ent]
    if dim then
        return self:getObject(dim)
    end
end




--[[
    call this whenever a dimension gets destroyed
    (:dimensionDestroyed event)

    If this isnt called, it's not the end of the world....
    we will just leak a bit of memory.
]]
function DimensionObject:destroyDimension(dimension)
    local obj = self.dimensionToObject[dimension]
    if obj then
        self:destroyObject(obj)
    end
    self.dimensionToObject[dimension] = nil
end




--[[
    This must be called whenever dimensions:entityMoved is called.
]]
function DimensionObject:entityMoved(ent, _oldDim, newDim)
    if not self:contains(ent) then
        return
    end

    local oldDim = self.entityToDimension[ent] or _oldDim

    local oldObj = self.dimensionToObject[oldDim]
    local newObj = self:getObject(newDim)

    self.entityToDimension[ent] = newDim -- set the new dimension

    -- move entity between objects:
    if oldObj then
        self:removeEntityFromObject(oldObj, ent)
    end
    self:addEntityToObject(newObj, ent)
end




--[[
    Adds entity to dstructure
]]
function DimensionObject:addEntity(ent)
    local dim = getDimension(ent)
    self.entityToDimension[ent] = dim
    local obj = self:getObject(dim)
    self:addEntityToObject(obj, ent)
end



--[[
    Removed entity from dstructure
]]
function DimensionObject:removeEntity(ent)
    local dim = self.entityToDimension[ent]
    self.entityToDimension[ent] = nil
    local obj = self:getObject(dim)
    self:removeEntityFromObject(obj, ent)
end



function DimensionObject:contains(ent)
    return self.entToDimension[ent]
end


function DimensionObject:hasDimension(dimension)
    return self.dimensionToObject[dimension]
end



--[[
==============================================================

Functions that need to be overridden:

==============================================================
]]

function DimensionObject:newObject()
    error("This needs to be overridden")
end


function DimensionObject:addEntityToObject(object, ent)
    error("This needs to be overridden")
end


function DimensionObject:removeEntityFromObject(object, ent)
    error("This needs to be overridden")
end



--[[
    Optional Overrides:
]]
function DimensionObject:destroyObject(object)
    -- Optional override
end


return DimensionObject

