
--[[
    
An "ItemHandle" is an object representing an item in an inventory slot.
Item

It's useful, because if that item is moved out of the inventory,
or if the item moves slots, the handle becomes invalid.

This allows other systems to use item handles for other abstract use
cases, such as:
- item holding
- armour
- passive item buffs

Each inventory may have ItemHandles.
ItemHandles are managed by the inventory internally.
Nothing needs to be done to manage them externally; they are fully
handled by the inventory itself.

]]


local ItemHandle = objects.Class("items:ItemHandle")


local initTc = typecheck.assert("number", "number", "entity")

function ItemHandle:init(slotX, slotY, itemEnt)
    initTc(slotX, slotY, itemEnt)
    self.slotX = slotX
    self.slotY = slotY
    self._item = itemEnt -- TODO: We NEED ephemeral components for this!
    self.valid = true
end


function ItemHandle:isValid()
    return self.valid
end


function ItemHandle:get()
    if self:isValid() then
        return self._item
    end
    error("ItemHandle was not valid! check using ih:isValid() before calling ih:get()")
end


local strTc = typecheck.assert("string")

function ItemHandle:setFlag(key, val)
    strTc(key)
    if ItemHandle[key] then
        error("Invalid flag: " .. key)
    end
    self[key] = val
end


function ItemHandle:getFlag(key)
    strTc(key)
    return self[key]
end


function ItemHandle:getSlot()
    return self.slotX, self.slotY
end


function ItemHandle:invalidate()
    self.valid = false
    self._item = nil
end
