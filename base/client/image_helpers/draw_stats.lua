
local operators = require("shared.operators")


local entityStats = {}


local ADD = operators.ADD
local MULT = operators.MULT



function entityStats.getOffsetX(ent)
    return (ent.ox or 0) + umg.ask("getOffsetX", ADD, ent) or 0
end

function entityStats.getOffsetY(ent)
    return (ent.oy or 0) + umg.ask("getOffsetY", ADD, ent) or 0
end

function entityStats.getRotation(ent)
    return (ent.rot or 0) + umg.ask("getRotation", ADD, ent) or 0
end


function entityStats.getScale(ent)
    return (ent.scale or 1) * (umg.ask("getScale", MULT, ent) or 1)
end

function entityStats.getScaleX(ent)
    return (ent.scaleX or 1) * (umg.ask("getScaleX", MULT, ent) or 1)
end

function entityStats.getScaleY(ent)
    return (ent.scaleY or 1) * (umg.ask("getScaleY", MULT, ent) or 1)
end


function entityStats.getShearX(ent)
    return (ent.shearX or 0) + (umg.ask("getShearX", ADD, ent) or 0)
end

function entityStats.getShearY(ent)
    return (ent.shearY or 0) + (umg.ask("getShearY", ADD, ent) or 0)
end


return entityStats
