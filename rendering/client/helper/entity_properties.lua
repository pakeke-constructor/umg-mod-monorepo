
require("rendering_questions")


local entityProperties = {}

local umg_ask = umg.ask




function entityProperties.getOffsetX(ent)
    return (ent.ox or 0) + (umg_ask("rendering:getOffsetX", ent) or 0)
end

function entityProperties.getOffsetY(ent)
    return (ent.oy or 0) + (umg_ask("rendering:getOffsetY", ent) or 0)
end

function entityProperties.getRotation(ent)
    return (ent.rot or 0) + (umg_ask("rendering:getRotation", ent) or 0)
end


function entityProperties.getScale(ent)
    return (ent.scale or 1) * (umg_ask("rendering:getScale", ent) or 1)
end

function entityProperties.getScaleX(ent)
    return (ent.scaleX or 1) * (umg_ask("rendering:getScaleX", ent) or 1)
end

function entityProperties.getScaleY(ent)
    return (ent.scaleY or 1) * (umg_ask("rendering:getScaleY", ent) or 1)
end


function entityProperties.getShearX(ent)
    return (ent.shearX or 0) + (umg_ask("rendering:getShearX", ent) or 0)
end

function entityProperties.getShearY(ent)
    return (ent.shearY or 0) + (umg_ask("rendering:getShearY", ent) or 0)
end



function entityProperties.getOpacity(ent)
    return (ent.opacity or 1) * (umg_ask("rendering:getOpacity", ent) or 1)
end

function entityProperties.getRed(ent)
    return umg_ask("rendering:getRed", ent) or 1
end

function entityProperties.getGreen(ent)
    return umg_ask("rendering:getGreen", ent) or 1
end

function entityProperties.getBlue(ent)
    return umg_ask("rendering:getBlue", ent) or 1
end



function entityProperties.getImage(ent)
    return umg_ask("rendering:getImage", ent) or ent.image 
end



return entityProperties

