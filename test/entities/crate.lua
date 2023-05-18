
return {
    image = "crate",
    openable = {
        distance = 100,
        public = true
    };

    init = function(ent, x,y)
        ent.x = x
        ent.y = y
        ent.inventory = items.Inventory({width=5;height=5, slotSeparation = 10})
    end;

    inventorySlots = {
        {false,false,false,false,true},
        {false,false,false,false,true},
        {true, true, true, true, true},
        {true, true, true, true, true},
        {true, true, true, true, true}
    },

    inventoryUI = {
       {
            x = 1, y = 1,
            width = 4, height = 2,
            render = function(ent)
                Slab.Text("hello!")
                Slab.Text("This UI is fully")
                Slab.Text("dynamic, and can")
                Slab.Text("be customized")
                Slab.Button("im a button")
            end
       }
    },

    light = {
        size = 240;
        color = {1,1,1}
    };
}

