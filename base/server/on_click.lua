

local RANGE_ACCEPTANCE = 40 



local function isInRange(ent, worldX, worldY)
    local dist = math.distance(ent.x - worldX, ent.y - worldY)
    return dist < RANGE_ACCEPTANCE
end



local sf = sync.filters


server.on("clickEntity", {
    arguments = {sf.entity, sf.number, sf.number, sf.number},
    handler = function(sender_uname, ent, button, worldX, worldY)
        if not (ent.onClick) then
            return
        end
        if button ~= 1 and button ~= 2 then
            return
        end
        if not isInRange(ent, worldX, worldY) then
            return
        end

        if type(ent.onClick) == "function" then
            ent:onClick(sender_uname, button, worldX, worldY)
        end
        umg.call("onClick", sender_uname, ent, button, worldX, worldY)
        server.broadcast("clickEntity", ent, sender_uname, button, worldX, worldY)
    end
})



