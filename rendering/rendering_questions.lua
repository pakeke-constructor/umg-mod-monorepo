

if not client then
    return
end


local ADD = reducers.ADD
local MULT = reducers.MULTIPLY


-- Camera positioning:

-- Flat camera offset. Answers should return 2 numbers
umg.defineQuestion("rendering:getCameraOffset", reducers.ADD_VECTOR)

-- Total camera position in world.
-- Answers should return x,y position, and then a priority.
-- The highest priority position is then chosen.
umg.defineQuestion("rendering:getCameraPosition", reducers.PRIORITY_DOUBLE)






--[[
    MODDER, BEWARE!!!!

    These questions below are asked very frequently.
    (Specifically, they are asked every time we draw an entity.)

    Do NOT include complex code in your answers!!!
    Every answer should be a fast, simple O(1) check.

    Also, try to not answers questions like these *too* many times,
    as it will cause a slight performance hit.
]]

-- Is the entity hidden? answers should return true or false
umg.defineQuestion("rendering:isHidden", reducers.OR)

-- gets offsets of an entity for draw position
-- TODO: Change these to to getOffsetXY?
umg.defineQuestion("rendering:getOffsetX", ADD)
umg.defineQuestion("rendering:getOffsetY", ADD)


-- get entity rotation
umg.defineQuestion("rendering:getRotation", ADD)

-- visual scale of entity
umg.defineQuestion("rendering:getScale", MULT)
-- TODO: Change these two to getScaleXY?
umg.defineQuestion("rendering:getScaleX", MULT)
umg.defineQuestion("rendering:getScaleY", MULT)

-- shear of entity
-- TODO: Change these two to getShearXY?
umg.defineQuestion("rendering:getShearX", ADD)
umg.defineQuestion("rendering:getShearY", ADD)


--[[
    TODO: do we really want to multiplicitively combine like this?
    Would it be possible to combine through OKLAB, or HSV or something?
]]
local function colorReducer(r1,r2, g1,g2, b1,b2)
    return ((r1 or 1)*(r2 or 1)), ((g1 or 1)*(g2 or 1)), ((b1 or 1)*(b2 or 1))
end

-- color of entity
umg.defineQuestion("rendering:getColor", colorReducer)

-- Opacity of entity
umg.defineQuestion("rendering:getOpacity", MULT)


-- ability to override image
umg.defineQuestion("rendering:getImage", reducers.PRIORITY)

