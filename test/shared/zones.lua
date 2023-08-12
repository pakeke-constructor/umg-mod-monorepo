

local yellowZone, cyanZone, magZone


if server then

local ents = server.entities

local OX, OY = 1200, 0
local D = 220



umg.on("@load", function()
    ents.yellowzone(OX-D, OY)
    ents.magzone(OX+D, OY)
    ents.cyanzone(OX, OY+D*(1.55))
end)

end




local yelGroup = umg.group("yellowZone")
local magGroup = umg.group("magentaZone")
local cyanGroup = umg.group("cyanZone")

umg.on("@tick", function()
    yellowZone = yelGroup[1]
    cyanZone = cyanGroup[1]
    magZone = magGroup[1]
end)




local function inRangeOf(ent, zoneEnt)
    if not zoneEnt then
        -- hacky for first iteration
        return false
    end
    assert(zoneEnt.size, "wot wot")
    local d = math.distance(ent.x - zoneEnt.x, ent.y - zoneEnt.y)
    return d < zoneEnt.size
end



if client then



local C = 0.3


umg.answer("rendering:getScale", function(ent)
    if inRangeOf(ent, yellowZone) then
        return 2
    end
end)
umg.answer("rendering:getColor", function(ent)
    if inRangeOf(ent, yellowZone) then
        return 1,1,C
    end
end)




umg.answer("rendering:getScaleX", function(ent)
    if inRangeOf(ent, magZone) then
        return 2
    end
end)
umg.answer("rendering:getColor", function(ent)
    if inRangeOf(ent, magZone) then
        return 1,C,1
    end
end)





umg.answer("rendering:getColor", function(ent)
    if inRangeOf(ent, cyanZone) then
        return C,1,1
    end
end)

end



umg.answer("xy:getVelocityMultiplier", function(ent)
    if inRangeOf(ent, cyanZone) then
        return 3
    end
end)
