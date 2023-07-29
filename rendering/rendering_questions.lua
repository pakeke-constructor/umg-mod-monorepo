

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
umg.defineQuestion("getOffsetX", ADD)
umg.defineQuestion("getOffsetY", ADD)
umg.defineQuestion("getRotation", ADD)

umg.defineQuestion("getScale", MULT)
umg.defineQuestion("getScaleX", MULT)
umg.defineQuestion("getScaleY", MULT)

umg.defineQuestion("getShearX", ADD)
umg.defineQuestion("getShearY", ADD)

umg.defineQuestion("getShearX", ADD)
umg.defineQuestion("getShearY", ADD)

umg.defineQuestion("getRed", MULT)
umg.defineQuestion("getBlue", MULT)
umg.defineQuestion("getGreen", MULT)
umg.defineQuestion("getOpacity", MULT)

umg.defineQuestion("getImage", reducers.PRIORITY)

