
--[[

Main drawing system for entities.
Will emit draw calls based on position, and in correct order.

]]

require("rendering_questions")
require("rendering_events")


local currentCamera = require("client.current_camera")

local constants = require("client.constants")

local ZIndexer = require("client.zindexer")





local dimensionToZIndexer = {}

local function getZIndexer(dim)
    dim = dimensions.getDimension(dim)
    if not dimensionToZIndexer[dim] then
        dimensionToZIndexer[dim] = ZIndexer(dim)
    end

    return dimensionToZIndexer[dim]
end




umg.on("dimensions:dimensionDestroyed", function(dim)
    dimensionToZIndexer[dim] = nil
end)



local function isDrawEntity(ent)
    if ent.draw and ent.x and ent.y then
        return true
    end
    return false
end





local function addToZIndexer(ent)
    local zindexer = getZIndexer(ent.dimension)
    zindexer:addEntity(ent)
end


local function removeFromZIndexer(ent, dim)
    -- removes entity from the ZIndexer for the specified dimension
    local zindexer = getZIndexer(dim)
    zindexer:removeEntity(ent)
end





local drawGroup = umg.group("x", "y", "draw")


drawGroup:onAdded(function(ent)
    addToZIndexer(ent)
end)

drawGroup:onRemoved(function(ent)
    removeFromZIndexer(ent, ent.dimension)
end)






umg.on("dimensions:entityMoved", function(ent, oldDimension, _newDim)
    -- This is a hacky and dumb way of doing things!
    if isDrawEntity(ent) then
        return
    end

    if oldDimension then
        removeFromZIndexer(ent, oldDimension)
    end

    addToZIndexer(ent)
end)





umg.on("@resize", function()
    local w,h = love.graphics.getDimensions()
    local camera = currentCamera.getCamera()
    camera.w = w
    camera.h = h
end)




--[[
    main draw function
]]
umg.on("rendering:drawEntities", function(camera)
    local dim = dimensions.getDimension(camera:getDimension())
    local zindexer = getZIndexer(dim)
    if zindexer then
        zindexer:drawEntities(camera)
    end
end)

