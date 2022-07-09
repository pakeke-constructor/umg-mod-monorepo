

return {
    "x","y",
    "stackSize",
    "hidden",
    maxStackSize = 20;
    image="block_item";
    itemName = "block";
    itemHoldImage = "slant_block";

    placeGridSize = 30;

    useItem = function(self, holderEnt, x, y)
        if server then
            local b = entities.block(x,y)
            b.x = x
            b.y = y
            b.vx = 0
            b.vy = 0
            b.image = "slant_block"
        end
    end;

    canUseItem = function(self, holder, x, y)
        return (math.floor(x/50 + y/50) % 2) == 0
    end;
    
    itemHoldType = "place"
}


