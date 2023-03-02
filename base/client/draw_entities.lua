
--[[

Main drawing system for entities.
Will emit draw calls based on position, and in correct order.

]]

local camera = require("client.camera")

local constants = require("shared.constants")


local drawGroup = umg.group("image", "x", "y")


local floor = math.floor
local max = math.max




-- Ordered drawing data structures:
local sortedFrozenEnts = {} -- for ents that dont move

local sortedMoveEnts = {} -- for ents that move




local setColor = love.graphics.setColor

local DEFAULT_LEIGHWAY = constants.SCREEN_LEIGHWAY




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



-- gets the "screen" Y from y and z position.
local function getDrawY(y, z)
    return y - (z or 0)/2
end


local function getDrawDepth(y,z)
    return floor(y + (z or 0))
end


local function getEntityDrawDepth(ent)
    local depth = ent.drawDepth or 0
    return getDrawDepth(ent.y + depth, ent.z)
end


local function entIsOnScreen(ent, leighway, w, h)
    --[[
        `ent` the entity to be checked if on screen

        OPTIONAL:
        `leighway` the leighway given. If not supplied, a sensible
            default is provided.
        `w` and `h` are the width and height of the screen. 
            If these aren't supplied, they will be automatically given.
            It's slightly faster if they are supplied though.

        leighway is just a constant that determines how many pixels
        of "leighway" we can give each object before it's counted as offscreen
    ]]
    leighway = leighway or DEFAULT_LEIGHWAY
    w, h = w or love.graphics.getWidth(), h or love.graphics.getHeight()
    local screen_y = getDrawY(ent.y, ent.z)
    local x, y = camera:toCameraCoords(ent.x, screen_y)

    local ret = -leighway <= x and x <= w + leighway
                and -leighway <= y and y <= h + leighway

    return ret
end


local function isOnScreen(x, y, leighway, w, h)
    --[[
        same as above, but for a direct x,y position as opposed to
        an entity.

        Assumes z = 0
    ]]
    leighway = leighway or DEFAULT_LEIGHWAY
    w, h = w or love.graphics.getWidth(), h or love.graphics.getHeight()
    x, y = camera:toCameraCoords(x, y)

    return -leighway <= x and x <= w + leighway
            and -leighway <= y and y <= h + leighway
end



local CAMERA_DEPTH_LEIGHWAY = 300

local function cameraTopDepth()
    local _, y = camera:toWorldCoords(0,-CAMERA_DEPTH_LEIGHWAY)
    return getDrawDepth(y, 0)
end

local function cameraBotDepth()
    local _, y = camera:toWorldCoords(0,love.graphics.getHeight() + CAMERA_DEPTH_LEIGHWAY)
    return getDrawDepth(y, 0)
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


drawGroup:onRemoved(function( ent )
    if ent:hasComponent("vy") or ent:hasComponent("vz") then
        -- the entity moves, its in the move array
        removeBufferMove[ent] = true
    else
        -- the entity doesnt move, its in the frozen array
        removeBufferFrozen[ent] = true
    end
end)


local function pollRemoveBuffer(array, removeBuffer)
    for i=#array,1,-1 do
        local ent = array[i]
        if removeBuffer[ent] then
            table.remove(array, i)
            removeBuffer[ent] = nil
        end
    end
end



umg.on("@resize", function()
    local w,h = love.graphics.getDimensions()
    camera.w = w
    camera.h = h
end)





local function less(ent_a, ent_b)
    return getEntityDrawDepth(ent_a) < getEntityDrawDepth(ent_b)
end



local froz_ct = 0

local function sortFrozenEnts()
    -- This function runes once every 50 frames:
    froz_ct = froz_ct + 1
    if froz_ct < 50 then
        return -- return early
    else
        froz_ct = 0 -- else, we run function
    end
    -- ==========
    -- The reason we don't need to sort every frame is because these entities
    -- dont have velocity components, so they probably aren't moving.
    table.sort(sortedFrozenEnts, less)
end



local function update()
    pollRemoveBuffer(sortedFrozenEnts, removeBufferFrozen)
    pollRemoveBuffer(sortedMoveEnts, removeBufferMove)

    table.sort(sortedMoveEnts, less)
    sortFrozenEnts()
    camera:update()
end





--[[
    main draw function
]]
umg.on("drawEntities", function()
    --[[
        explanation:
        We have two sorted lists of entities:
        frozen ents, and moving ents.

        We sort the moving entities every frame.
        When we go to draw them, we iterate through both lists at once,
        and take the entity with the biggest screen Y.
    ]]
    update()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    
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
        if entIsOnScreen(draw_ent, DEFAULT_LEIGHWAY, w, h) and (not draw_ent.hidden) then
            setColor(1,1,1)
            if draw_ent.image then
                if draw_ent.color then
                    setColor(draw_ent.color)
                end
                umg.call("drawEntity", draw_ent)
                if draw_ent.onDraw then
                    draw_ent:onDraw()
                end
            end
        end

        for dep=last_draw_dep+1, draw_dep do
            umg.call("drawIndex", dep)
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






return {
    camera = camera;

    getDrawY = getDrawY;
    getDrawDepth = getDrawDepth;
    getEntityDrawDepth = getEntityDrawDepth;

    isOnScreen = isOnScreen;
    entIsOnScreen = entIsOnScreen
}


