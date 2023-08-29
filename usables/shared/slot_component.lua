
--[[

holdItemSlot component -> 
{
    slotX = 1,
    slotY = 2
}

if an item gets put in the slot, then it is automatically equipped.

]]


local HoldSlotHandle = require("shared.hold_slot_handle")


local group = umg.group("inventory", "holdItemSlot")

group:onAdded(function(ent)
    local inv = ent.inventory
    local his = ent.holdItemSlot
    assert(his.slotX and his.slotY, "holdItemSlot not given slotX, slotY")

    local obj = HoldSlotHandle(inv)
    inv:setSlotHandle(his.slotX, his.slotY, obj)
end)

