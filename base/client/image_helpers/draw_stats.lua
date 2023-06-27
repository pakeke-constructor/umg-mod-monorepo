
local operators = require("shared.operators")


local drawStats = {}


local ADD = operators.ADD
local MULT = operators.MULT



function drawStats.getOffsetX(ent)
    return (ent.ox or 0) + (umg.ask("getOffsetX", ADD, ent) or 0)
end

function drawStats.getOffsetY(ent)
    return (ent.oy or 0) + (umg.ask("getOffsetY", ADD, ent) or 0)
end

function drawStats.getRotation(ent)
    return (ent.rot or 0) + (umg.ask("getRotation", ADD, ent) or 0)
end


function drawStats.getScale(ent)
    return (ent.scale or 1) * (umg.ask("getScale", MULT, ent) or 1)
end

function drawStats.getScaleX(ent)
    return (ent.scaleX or 1) * (umg.ask("getScaleX", MULT, ent) or 1)
end

function drawStats.getScaleY(ent)
    return (ent.scaleY or 1) * (umg.ask("getScaleY", MULT, ent) or 1)
end


function drawStats.getShearX(ent)
    return (ent.shearX or 0) + (umg.ask("getShearX", ADD, ent) or 0)
end

function drawStats.getShearY(ent)
    return (ent.shearY or 0) + (umg.ask("getShearY", ADD, ent) or 0)
end



function drawStats.getOpacity(ent)
    return (ent.opacity or 1) * (umg.ask("getOpacity", MULT, ent) or 1)
end

function drawStats.getRed(ent)
    return umg.ask("getRed", MULT, ent) or 1
end

function drawStats.getGreen(ent)
    return umg.ask("getGreen", MULT, ent) or 1
end

function drawStats.getBlue(ent)
    return umg.ask("getBlue", MULT, ent) or 1
end


return drawStats
