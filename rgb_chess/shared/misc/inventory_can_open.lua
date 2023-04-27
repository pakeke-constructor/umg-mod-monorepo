

umg.answer("canOpenInventory", function(ent, inventory)
    -- entities can open other inventories if they are in the same rgbTeam.
    local owner = inventory.owner
    return owner.rgbTeam == ent.rgbTeam
end)

