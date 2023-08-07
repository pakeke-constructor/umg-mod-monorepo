
local OR = reducers.OR


-- whether an inventory can be opened
umg.defineQuestion("items:canOpenInventory", OR)

-- whether an inv is locked
umg.defineQuestion("items:isInventoryLocked", OR)

-- whether an item is blocked from being removed from an inventory
umg.defineQuestion("items:isItemRemovalBlocked", OR)

-- whether an item is blocked from being added to an inventory
umg.defineQuestion("items:isItemAdditionBlocked", OR)




-- item usage
--[[
    TODO: Should we move all this to the `usables` mod?
]]

umg.defineQuestion("items:itemUsageBlocked", reducers.OR)

