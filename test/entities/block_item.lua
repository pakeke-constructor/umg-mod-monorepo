
return placement.newPlaceable({
    "x","y",
    "stackSize",
    "hidden",
    "itemBeingHeld",
    maxStackSize = 20;
    image="block_item";
    itemName = "block";
    itemHoldImage = "slant_block";

    placeGridSize = 30;
   
    itemHoldType = "place";

    spawn = function(x,y)
        if server then
            local e = entities.block()
            e.x = x
            e.y = y
            e.image = "slant_block"
        else
            base.shockwave(x,y,5,50,5,0.5)
        end
    end
})

