

--[[

hash of valid callbacks.

If an inventory callback is created and it is not in this hash, 
an error should be thrown.

]]

return {
    canAdd = true;
    canRemove = true;
    canOpen = true;

    onAdd = true;
    onRemove = true;
    onOpen = true;
    draw = true
}


