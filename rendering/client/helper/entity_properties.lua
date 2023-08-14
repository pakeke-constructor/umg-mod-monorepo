
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
    local a = 1
    if ent.color and ent.color[4] then
        a = ent.color[4]
    end
    return a * (ent.opacity or 1) * (umg_ask("rendering:getOpacity", ent) or 1)
end



function entityProperties.getColor(ent)
    local r,g,b = umg_ask("rendering:getColor", ent)
    if not r then
        r,g,b = 1,1,1
    end

    local color = ent.color
    if color then
        return r*color[1], g*color[2], b*color[3]
    end
    return r,g,b
end


function entityProperties.getImage(ent)
    return umg_ask("rendering:getImage", ent) or ent.image 
end


function entityProperties.isHidden(ent)
    return ent.hidden or umg.ask("rendering:isHidden", ent)
end


return entityProperties
