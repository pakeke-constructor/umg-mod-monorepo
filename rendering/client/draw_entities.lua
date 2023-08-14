
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
local max = math.max




-- Ordered drawing data structures:
local sortedFrozenEnts = {} -- for ents that dont move

local sortedMoveEnts = {} -- for ents that move









local function binarySearch(arr, targ_draw_dep, keyfunc)
    --[[
        returns the index for a target draw depth.
    ]]
	local low = 1
	local high = #arr
	while low <= high do
		local mid = floor((low + high) / 2)
		local mid_val = arr[mid]
		if targ_draw_dep < keyfunc(mid_val) then
			high = mid - 1
		else
			low = mid + 1
		end
	end
    return low
end







local CAMERA_DEPTH_LEIGHWAY = 600

local function cameraTopDepth()
    local camera = currentCamera.getCamera()
    local _, y = camera:toWorldCoords(0,-CAMERA_DEPTH_LEIGHWAY)
    return getDrawDepth(y - CAMERA_DEPTH_LEIGHWAY, 0)
end

local function cameraBotDepth()
    local camera = currentCamera.getCamera()
    local _, y = camera:toWorldCoords(0,love.graphics.getHeight() + CAMERA_DEPTH_LEIGHWAY)
    return getDrawDepth(y + CAMERA_DEPTH_LEIGHWAY, 0)
end








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



local removeBufferMove = {} --  [ent] -> true   entity needs to be removed.
local removeBufferFrozen = {}-- [ent] -> true   entity needs to be removed.


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
    sort.stable_sort(sortedFrozenEnts, less)
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
    --[[
        explanation:
        We have two sorted lists of entities:
        frozen ents, and moving ents.

        We sort the moving entities every frame.
        When we go to draw them, we iterate through both lists at once,
        and take the entity with the biggest screen Y.
    ]]
    update()
    
    local draw_dep
    local draw_ent

    local min_depth = cameraTopDepth() -- top depth = smaller screenY
    local max_depth = cameraBotDepth() -- bot depth is bigger screenY

    -- we start at the bottom of the screen, and work up.
    local frozen_i = max(1, binarySearch(sortedFrozenEnts, min_depth, getEntityDrawDepth))
    local moving_i = max(1, binarySearch(sortedMoveEnts, min_depth, getEntityDrawDepth))
    local frozen_ent = sortedFrozenEnts[frozen_i]
    local moving_ent = sortedMoveEnts[moving_i]
    local frozen_dep
    local moving_dep

    frozen_dep = frozen_ent and getEntityDrawDepth(frozen_ent) or 0xffffffffff
    moving_dep = moving_ent and getEntityDrawDepth(moving_ent) or 0xffffffffff
    
    if frozen_dep < moving_dep then
        -- then we draw entity from frozen list
        frozen_i = frozen_i + 1
        draw_ent = frozen_ent
        frozen_ent = sortedFrozenEnts[frozen_i]
        draw_dep = frozen_dep
    else --  else draw entity from moving list
        moving_i = moving_i + 1
        draw_ent = moving_ent
        moving_ent = sortedMoveEnts[moving_i]
        draw_dep = moving_dep
    end

    local last_draw_dep = draw_dep

    while draw_ent and draw_dep < max_depth do
        drawEntity(draw_ent)

        for dep=last_draw_dep+1, draw_dep do
            -- TODO: Since we don't check camera bounds, this is some HOT GARBAGE code.
            -- If entities are very far apart, this loop may very well be called like 1 million times.
            -- We should check if the Y pos is on screen before doing something stupid like this;
            -- that way we won't hit a bajillion iterations in this loop
            umg.call("rendering:drawIndex", dep)
        end
        last_draw_dep = draw_dep

        -- select next draw entity:
        frozen_dep = frozen_ent and getEntityDrawDepth(frozen_ent) or 0xffffffffff
        moving_dep = moving_ent and getEntityDrawDepth(moving_ent) or 0xffffffffff
        if frozen_dep < moving_dep then
            -- then we draw entity from frozen list
            frozen_i = frozen_i + 1
            draw_ent = frozen_ent
            frozen_ent = sortedFrozenEnts[frozen_i]
            draw_dep = frozen_dep
        else --  else draw entity from moving list
            moving_i = moving_i + 1
            draw_ent = moving_ent
            moving_ent = sortedMoveEnts[moving_i]
            draw_dep = moving_dep
        end
    
    end

    client.atlas:flush()
end)

