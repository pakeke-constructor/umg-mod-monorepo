
-- an entity equips an item
umg.defineEvent("usables:equipItem")

-- an entity un-equips an item
umg.defineEvent("usables:unequipItem")


-- An item is used:
umg.defineEvent("usables:useItem")

-- item usage is denied:
umg.defineEvent("usables:useItemDeny")


-- A hold item is updated. 
-- Called every frame whilst an item is being held
umg.defineEvent("usables:updateHoldItem")

