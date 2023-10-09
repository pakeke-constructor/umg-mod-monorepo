
--[[

Main drawing system for entities.
Will emit draw calls based on position, and in correct order.

]]

require("rendering_questions")
require("rendering_events")


local currentCamera = require("client.current_camera")

local constants = require("client.constants")

local DimensionZIndexer = require("client.dimension_zindexer")


local dimensionZIndexer = DimensionZIndexer()
-- ^^^ is an instance of dimensions.DimensionStructure



umg.on("dimensions:dimensionDestroyed", function(dim)
    dimensionZIndexer:destroyDimension(dim)
end)



local drawGroup = umg.group("x", "y", "drawable")


drawGroup:onAdded(function(ent)
    dimensionZIndexer:addEntity(ent)
end)


drawGroup:onRemoved(function(ent)
    dimensionZIndexer:removeEntity(ent)
end)



umg.on("dimensions:entityMoved", function(ent, oldDim, newDim)
    -- This is called for entities that aren't draw entities,
    -- but oh well.
    -- The DimensionStructure will handle it gracefully.
    dimensionZIndexer:entityMoved(ent, oldDim, newDim)
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
    local zindexer = dimensionZIndexer:getObject(dim)
    if zindexer then
        zindexer:drawEntities(camera)
    end
end)

