

--[[

hash of valid callbacks.

If an inventory callback is created and it is not in this hash, 
an error should be thrown.

]]

return {
    canAdd = true; -- returns true/false:  whether or not an item can be added
    canRemove = true; -- returns true/false:  whether or not an item can be removed
    canOpen = true; -- returns true/false:  whether or not an inventory can be opened

    slotExists = true; -- returns whether the given slot should exist or not.
    -- useful for creating crafting devices, smelters, composters, etc, stuff like that.

    onAdd = true; 
    onRemove = true;
    onOpen = true;
    draw = true
}


