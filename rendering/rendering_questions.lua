

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
umg.defineQuestion("rendering:getOffsetX", ADD)
umg.defineQuestion("rendering:getOffsetY", ADD)


-- get entity rotation
umg.defineQuestion("rendering:getRotation", ADD)

-- visual scale of entity
umg.defineQuestion("rendering:getScale", MULT)
umg.defineQuestion("rendering:getScaleX", MULT)
umg.defineQuestion("rendering:getScaleY", MULT)

-- shear of entity
umg.defineQuestion("rendering:getShearX", ADD)
umg.defineQuestion("rendering:getShearY", ADD)


-- color of entity
umg.defineQuestion("rendering:getRed", MULT)
umg.defineQuestion("rendering:getBlue", MULT)
umg.defineQuestion("rendering:getGreen", MULT)
umg.defineQuestion("rendering:getOpacity", MULT)

-- ability to override image
umg.defineQuestion("rendering:getImage", reducers.PRIORITY)

