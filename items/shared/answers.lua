
local constants = require("shared.constants")


umg.answer("canOpenInventory", function(ent, inventory)
    --[[
        entities can always open inventories if they own the inventory
    ]]
    local owner = inventory.owner
    if ent == owner then
        return true
    end

    if owner.controller == ent.controller then
        return true
    end
    return false
end)






umg.answer("canOpenInventory", function(ent, inventory)
    --[[
        entities can open inventories if they are public,
        and are within range in terms of position.
    ]]
    local invEnt = inventory.owner
    if invEnt.openable and invEnt.openable.public and invEnt.x and invEnt.y then
        if ent.x and ent.y then
            local dist = math.distance(ent, invEnt)
            if dist <= (invEnt.openable.distance or constants.DEFAULT_OPENABLE_DISTANCE) then
                return true
            end
        end
    end
    return false
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
    return false
end)


