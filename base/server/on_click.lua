

local RANGE_ACCEPTANCE = 20 



local function isInRange(ent, worldX, worldY)
    local dist = math.distance(ent.x - worldX, ent.y - worldY)
    return dist > RANGE_ACCEPTANCE
end




server.on("clickEntity", function(sender, ent, button, worldX, worldY)
    if not (exists(ent) and ent.onClick) then
        return
    end
    if button ~= 1 and button ~= 2 then
        return
    end
    if not isInRange(ent, worldX, worldY) then
        return
    end
    ent:onClick(sender, button, worldX, worldY)
    server.broadcast("clickEntity", ent, button, worldX, worldY)
end)



