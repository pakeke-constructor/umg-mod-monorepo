

--[[

Automatically holds items in a given slot

]]

local common = require("shared.common")
local holding = require("shared.holding")

local autoHoldGroup = umg.group("inventory", "holdItemSlot")



autoHoldGroup:onAdded(function(ent)
    local holdItemSlot = ent.holdItemSlot
    local slotX, slotY = holdItemSlot.slotX, holdItemSlot.slotY
    assert(type(slotX) == "number", "bad value for holdItemSlot")
    assert(type(slotY) == "number", "bad value for holdItemSlot")
end)




local function updateEnt(ent)
    local holdItemSlot = ent.holdItemSlot
    local inv = ent.inventory
    local slotX, slotY = holdItemSlot.slotX, holdItemSlot.slotY

    local item = inv:get(slotX, slotY)
    local holdItem = common.getHoldItem(ent)
    
    if item and item ~= holdItem then
        holding.equipItem(ent, slotX, slotY)
    end
end



umg.on("@tick", function()
    for _, ent in ipairs(autoHoldGroup)do
        updateEnt(ent)
    end
end)


