

umg.answer("canOpenInventory", function(ent, inventory)
    --[[
        entities can always open inventories if they own
        the inventory, or if the inventory is public.
    ]]
    local owner = inventory.owner
    if ent == owner then
        return true
    end

    if inventory.public then
        return true
    end

    if owner.controller == ent.controller then
        return true
    end
end)



umg.answer("canOpenInventory", function(ent, inventory)
    --[[
        entities can also open inventories if the
        `canOpen` callback says so!
    ]]
    local func = ent.inventoryCallbacks and ent.inventoryCallbacks.canOpen
    if func and func(inventory, ent) then
        return true
    end
end)


