

if not client then
    return
end


local ADD = reducers.ADD
local MULT = reducers.MULTIPLY


--[[
    MODDER, BEWARE!!!!

    These questions are asked very frequently.
    (Specifically, they are asked every time we draw an entity.)

    Do NOT include complex code in your answers!!!
    Every answer should be a fast, simple O(1) check.

    Also, try to keep answers for these questions to a minimum, as to
    not put a strain on performance.
]]
umg.defineQuestion("rendering:getOffsetX", ADD)
umg.defineQuestion("rendering:getOffsetY", ADD)
umg.defineQuestion("rendering:getRotation", ADD)

umg.defineQuestion("rendering:getScale", MULT)
umg.defineQuestion("rendering:getScaleX", MULT)
umg.defineQuestion("rendering:getScaleY", MULT)

umg.defineQuestion("rendering:getShearX", ADD)
umg.defineQuestion("rendering:getShearY", ADD)

umg.defineQuestion("rendering:getShearX", ADD)
umg.defineQuestion("rendering:getShearY", ADD)

umg.defineQuestion("rendering:getRed", MULT)
umg.defineQuestion("rendering:getBlue", MULT)
umg.defineQuestion("rendering:getGreen", MULT)
umg.defineQuestion("rendering:getOpacity", MULT)

umg.defineQuestion("rendering:getImage", reducers.PRIORITY)

