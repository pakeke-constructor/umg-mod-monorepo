
local makeInventoryGroup = umg.group("rgbUnit", "makeUnitInventory")


makeInventoryGroup:onAdded(function(ent)
    local opt = ent.makeUnitInventory
    if not opt then
        return
    end

    local w,h = opt.width, opt.height
    ent.inventory = items.Inventory({
        width = w, height = h
    })
end)

