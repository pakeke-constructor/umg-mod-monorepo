

local yellowZone, cyanZone, magZone


if server then

local ents = server.entities
umg.on("@load", function()
    ents.yellowzone(-200, 0)
    ents.magzone(200, 0)
    ents.cyanzone(0, 200)
end)

end




local yelGroup = umg.group("yellowZone")
local cyanGroup = umg.group("magentaZone")
local magGroup = umg.group("cyanZone")

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
        return -1
    end
end)
umg.answer("rendering:getColor", function(ent)
    if inRangeOf(ent, magZone) then
        return 1,C,1
    end
end)





umg.answer("rendering:getColor", function(ent)
    if inRangeOf(ent, magZone) then
        return 1,1,C
    end
end)

end



umg.answer("xy:getSpeed", function(ent)
    if inRangeOf(ent, cyanZone) then
        return 0.6
    end
end)
