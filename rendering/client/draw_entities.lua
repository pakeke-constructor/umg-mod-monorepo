
--[[

Main drawing system for entities.
Will emit draw calls based on position, and in correct order.

]]

require("rendering_questions")
require("rendering_events")


local currentCamera = require("client.current_camera")

local constants = require("client.constants")
local sort = require("libs.sort")




local drawGroup = umg.group("draw", "x", "y")


local floor = math.floor















drawGroup:onAdded(function( ent )
    -- Callback for entity addition
    if ent:hasComponent("vy") or ent:hasComponent("vz") then
        -- then the entity moves, add it to move array
        local i = binarySearch(sortedMoveEnts, getEntityDrawDepth(ent), getEntityDrawDepth)
        table.insert(sortedMoveEnts, i, ent)
    else
        -- the entity doesn't move, add it to frozen array
        local i = binarySearch(sortedFrozenEnts, getEntityDrawDepth(ent), getEntityDrawDepth)
        table.insert(sortedFrozenEnts, i, ent)
    end
end)



drawGroup:onRemoved(function(ent)
    removeBufferMove[ent] = true
    removeBufferFrozen[ent] = true
end)



umg.on("@resize", function()
    local w,h = love.graphics.getDimensions()
    local camera = currentCamera.getCamera()
    camera.w = w
    camera.h = h
end)









local function sortFrozenEnts()
    error([[
        for each ZIndexer zind:
            zind:heavyUpdate()
    ]])
end


-- The reason we don't need to sort every frame is because these entities
-- dont have velocity components, so they probably aren't moving.
-- we still want to sort them some-times tho, hence why we sort them every 50 frames
scheduling.runEvery(50, "@update", sortFrozenEnts)
error("^^^ move this to ZIndexer")






--[[
    main draw function
]]
umg.on("rendering:drawEntities", function()
end)

