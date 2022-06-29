


server.on("setInventoryHoldValues", function(sender, ent, faceDir, hold_x, hold_y, dx, dy)
    server.broadcast("setInventoryHoldValues", ent, faceDir, hold_x, hold_y, dx, dy)
end)



local directions = {
    up=true; down=true; left=true; right=true
}

server.filter("setInventoryHoldValues", function(sender, ent, faceDir, hold_x, hold_y, dx, dy)
    if not exists(ent)
        or ent.controller ~= sender 
        or (not ent.inventory)
        or (not directions[faceDir])
        or type(dx)~="number" 
        or type(dy)~="number" 
        or type(hold_x)~="number"
        or type(hold_y)~="number"
    then
        return false
    end
    return true
end)




--[[

TODO:
Do planning for this.

]]
server.on("useItem", function(sender, holder, item, ...)
end)


server.filter("useItem", function(sender, holder, item)
    return exists(holder) and exists(item) and holder.controller
end)

