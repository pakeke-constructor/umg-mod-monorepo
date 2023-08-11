

local yellowZone, cyanZone, magZone


if server then

umg.on("@load", function()
    yellowZone = server.entities.yellowzone()
    cyanZone = server.entities.cyanzone()
    magZone = server.entities.magzone()
end)

end



local zones

local yelGroup = umg.group("yellowZone")
local cyanGroup = umg.group("magentaZone")
local magGroup = umg.group("cyanZone")

umg.on("@tick", function()
    yellowZone = yelGroup[1]
    cyanZone = cyanGroup[1]
    magZone = magGroup[1]
    zones = {yellowZone, cyanZone, magZone}
end)




local function inRangeOf(ent, zoneEnt)
    assert(zoneEnt.size, "wot wot")
    local d = math.distance(ent.x - zoneEnt.x, ent.y - zoneEnt.y)
    return d < zoneEnt.size
end



if client then


--[[
yellow: scale

aqua: 


]]

umg.on("rendering:getScale", function(ent)
    if inRangeOf(ent, yellowZone) then
        return 2
    end
end)

umg.on("rendering:getScaleX", function(ent)

end)


umg.on("rendering:getColor", function(ent)
end)

end