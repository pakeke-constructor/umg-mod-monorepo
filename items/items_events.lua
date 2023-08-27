
-- item is moved in an inventory
umg.defineEvent("items:itemAdded")

-- item is removed from an inventory
umg.defineEvent("items:itemRemoved")


-- an inventory is opened
umg.defineEvent("items:openInventory")


-- an inventory is closed
umg.defineEvent("items:closeInventory")




if client then

--  an inventory item is drawn WITHIN the inventory
umg.defineEvent("items:drawInventoryItem")

-- inventory item info is to be drawn (through a Slab UI context)
umg.defineEvent("items:displayItemTooltip")

-- an inventory is drawn. Note that this is scaled by the UI Scale!
umg.defineEvent("items:drawInventory")

end



-- item dropped on ground
umg.defineEvent("items:dropGroundItem")

-- item picked up from ground
umg.defineEvent("items:pickupGroundItem")

