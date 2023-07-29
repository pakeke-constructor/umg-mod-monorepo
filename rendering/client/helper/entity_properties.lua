


local entityProperties = {}

local umg_ask = umg.ask




function entityProperties.getOffsetX(ent)
    return (ent.ox or 0) + (umg_ask("getOffsetX", ent))
end

function entityProperties.getOffsetY(ent)
    return (ent.oy or 0) + (umg_ask("getOffsetY", ent))
end

function entityProperties.getRotation(ent)
    return (ent.rot or 0) + (umg_ask("getRotation", ent))
end


function entityProperties.getScale(ent)
    return (ent.scale or 1) * (umg_ask("getScale", ent))
end

function entityProperties.getScaleX(ent)
    return (ent.scaleX or 1) * (umg_ask("getScaleX", ent))
end

function entityProperties.getScaleY(ent)
    return (ent.scaleY or 1) * (umg_ask("getScaleY", ent))
end


function entityProperties.getShearX(ent)
    return (ent.shearX or 0) + umg_ask("getShearX", ent)
end

function entityProperties.getShearY(ent)
    return (ent.shearY or 0) + umg_ask("getShearY", ent)
end



function entityProperties.getOpacity(ent)
    return (ent.opacity or 1) * umg_ask("getOpacity", ent) 
end

function entityProperties.getRed(ent)
    return umg_ask("getRed", ent) or 1
end

function entityProperties.getGreen(ent)
    return umg_ask("getGreen", ent) or 1
end

function entityProperties.getBlue(ent)
    return umg_ask("getBlue", ent) or 1
end



function entityProperties.getImage(ent)
    return umg_ask("getImage", ent) or ent.image 
end



return entityProperties

