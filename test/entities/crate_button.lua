


return {
    "inventory",
    "x","y",
    image = "crate",
    openable = {distance = 100};

    inventoryButtons = {
        [{1,1}] = function() print("working") end
    };

    init = function(ent, x,y)
        ent.x = x
        ent.y = y
        ent.inventory = {width=2;height=2}
    end
}



