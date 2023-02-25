


return {
    image = "crate",
    openable = {distance = 100};

    init = function(ent, x,y)
        ent.x = x
        ent.y = y
        ent.inventory = items.Inventory({width=2;height=2})
    end
}



