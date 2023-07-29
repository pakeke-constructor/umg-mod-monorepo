


local drawStats = {}





function drawStats.getOffsetX(ent)
    return (ent.ox or 0) + (umg.ask("getOffsetX", ent))
end

function drawStats.getOffsetY(ent)
    return (ent.oy or 0) + (umg.ask("getOffsetY", ent))
end

function drawStats.getRotation(ent)
    return (ent.rot or 0) + (umg.ask("getRotation", ent))
end


function drawStats.getScale(ent)
    return (ent.scale or 1) * (umg.ask("getScale", ent))
end

function drawStats.getScaleX(ent)
    return (ent.scaleX or 1) * (umg.ask("getScaleX", ent))
end

function drawStats.getScaleY(ent)
    return (ent.scaleY or 1) * (umg.ask("getScaleY", ent))
end


function drawStats.getShearX(ent)
    return (ent.shearX or 0) + umg.ask("getShearX", ent)
end

function drawStats.getShearY(ent)
    return (ent.shearY or 0) + umg.ask("getShearY", ent)
end



function drawStats.getOpacity(ent)
    return (ent.opacity or 1) * umg.ask("getOpacity", ent) 
end

function drawStats.getRed(ent)
    return umg.ask("getRed", ent) or 1
end

function drawStats.getGreen(ent)
    return umg.ask("getGreen", ent) or 1
end

function drawStats.getBlue(ent)
    return umg.ask("getBlue", ent) or 1
end


return drawStats
