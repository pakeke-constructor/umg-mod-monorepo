


server.on("setInventoryHoldValues", function(sender, ent, hold_x, hold_y, dx, dy)
    server.broadcast("setInventoryHoldValues", ent, hold_x, hold_y, dx, dy)
end)




server.filter("setInventoryHoldValues", function(sender, ent, hold_x, hold_y, dx, dy)
    if ent.controller ~= sender 
        or (not ent.inventory)
        or type(dx)~="number" 
        or type(dy)~="number" 
        or type(hold_x)~="number"
        or type(hold_y)~="number"
    then
        return false
    end
    return true
end)



