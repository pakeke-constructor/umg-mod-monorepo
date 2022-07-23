


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





local updateStackSize = require("server.update_stacksize")


local itemGroup = group("itemName", "stackSize", "maxStackSize")


itemGroup:onAdded(function(item_ent)
    if not item_ent.stackSize then
        item_ent.stackSize = 1
    end
    item_ent.last_seen_stackSize = item_ent.stackSize
end)


on("tick", function()
    for _, item_ent in ipairs(itemGroup) do
        updateStackSize(item_ent)
    end
end)




