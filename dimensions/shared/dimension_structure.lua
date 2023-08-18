
--[[

A DimensionStructure is an abstract data structure that contains
other Objects for each dimension.

It's best understood through examples:


For example:
In the physics system, each dimension gets it's own physics world.
Each physics world is stored cleanly inside of the `DimensionStructure`.
The DimensionStructure handles moving entities between dimensions, by simply
removing entities from one physics world, and putting them in another.

Another example:
For rendering, each dimension has a ZIndexer data structure.
(for ordered drawing.)
All of the ZIndexers are handled by the DimensionStructure.
entities are moved between ZIndexers when they moved dimensions.
(provided DimensionStructure:entityMoved() is called)

-------------------------

There are 4 main functions that NEED to be called manually, or else it wont work:

DimensionStructure:super()  must be called on init
DimensionStructure:addEntity(ent)  adds entity
DimensionStructure:removeEntity(ent)  removes entity
DimensionStructure:entityMoved(ent, oldDim, newDim)  call this whenever `dimensions:entityMoved` event is called

]]

require("shared.dimension_vector") -- we need typecheck defs

local getDimension = require("shared.get_dimension")


local DimensionStructure = objects.Class("dimensions:DimensionStructure")




function DimensionStructure:super()
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
function DimensionStructure:getObject(dimension)
    if self.dimensionToObject[dimension] then
        return self.dimensionToObject[dimension]
    end

    local partition = self:newObject(dimension)
    self.dimensionToObject[dimension] = partition
    return partition
end



--[[
    Gets the object that contains the given entity.
]] 
function DimensionStructure:getObjectForEntity(ent)
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
function DimensionStructure:destroyDimension(dimension)
    local obj = self.dimensionToObject[dimension]
    if obj then
        self:destroyObject(obj)
    end
    self.dimensionToObject[dimension] = nil
end


--[[
    this doesn't actually *need* to be called.
    But you should call it whenever there's a `:dimensionCreated` event.
]]
function DimensionStructure:createDimension(dimension)
    self:getObject(dimension)
end




--[[
    This must be called whenever dimensions:entityMoved is called.
]]
function DimensionStructure:entityMoved(ent, _oldDim, newDim)
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
function DimensionStructure:addEntity(ent)
    local dim = getDimension(ent)
    self.entityToDimension[ent] = dim
    local obj = self:getObject(dim)
    self:addEntityToObject(obj, ent)
end



--[[
    Removed entity from dstructure
]]
function DimensionStructure:removeEntity(ent)
    local dim = self.entityToDimension[ent]
    self.entityToDimension[ent] = nil
    local obj = self:getObject(dim)
    self:removeEntityFromObject(obj, ent)
end



function DimensionStructure:contains(ent)
    return self.entityToDimension[ent]
end


function DimensionStructure:hasDimension(dimension)
    return self.dimensionToObject[dimension]
end



--[[
==============================================================

Functions that need to be overridden:

==============================================================
]]

function DimensionStructure:newObject(dimension)
    error("This needs to be overridden")
end


function DimensionStructure:addEntityToObject(object, ent)
    error("This needs to be overridden")
end


function DimensionStructure:removeEntityFromObject(object, ent)
    error("This needs to be overridden")
end



--[[
    Optional Overrides:
]]
function DimensionStructure:destroyObject(object)
    -- Optional override
end


return DimensionStructure
