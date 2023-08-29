
--[[

Represents a slot in the inventory, where if an item goes to that slot,
the item is automatically equipped.

If the item is removed from that slot, then the item is automatically
unequipped.

]]


local extends = items.SlotHandle
local HoldSlotHandle = objects.Class("usables:HoldSlotHandle", extends)




local holding = require("shared.holding")



function HoldSlotHandle:onItemAdded(itemEnt)
    if server then
        local holderEnt = self:getOwner()
        holding.equipItem(holderEnt, itemEnt)
    end
end


function HoldSlotHandle:onItemRemoved(itemEnt)
    if server then
        print("YO!!! ", itemEnt)
        local holderEnt = self:getOwner()
        holding.unequipItem(holderEnt, itemEnt)
    end
end


return HoldSlotHandle

