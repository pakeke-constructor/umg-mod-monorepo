


return {
    image = "crate",
    openable = {distance = 100};

    inventoryCallbacks = {
        slotExists = function(inv,x,y)
            if (x==1) and (y==1) then return false end
            return true
        end
    };

    init = function(ent, x,y)
        ent.x = x
        ent.y = y
        ent.inventory = items.Inventory({width=2;height=2})
    end
}



