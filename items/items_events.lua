
-- inventory slot is clicked on / hovered
umg.defineEvent("items:hoverInventorySlot")

-- item is added to an inventory
umg.defineEvent("items:itemAdded")

-- item is removed from an inventory
umg.defineEvent("items:itemRemoved")


-- an inventory is opened
umg.defineEvent("items:openInventory")


-- an inventory is closed
umg.defineEvent("items:closeInventory")



-- an entity equips an item
umg.defineEvent("items:equipItem")

-- an entity un-equips an item
umg.defineEvent("items:unequipItem")




if client then

--  an inventory item is drawn WITHIN the inventory
umg.defineEvent("items:drawInventoryItem")

-- inventory item info is to be drawn (through a Slab UI context)
umg.defineEvent("items:displayItemTooltip")

-- an inventory is drawn. Note that this is scaled by the UI Scale!
umg.defineEvent("items:drawInventory")

end




-- An item is used
umg.defineEvent("items:useItem")



-- item dropped on ground
umg.defineEvent("items:dropGroundItem")

-- item picked up from ground
umg.defineEvent("items:pickupGroundItem")

