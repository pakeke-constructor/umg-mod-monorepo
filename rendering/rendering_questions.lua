

if not client then
    return
end


local ADD = reducers.ADD
local MULT = reducers.MULTIPLY


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

