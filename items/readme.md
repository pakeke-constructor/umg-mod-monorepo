
# inventory mod

This mod adds items and Inventories.

With inventories, you can make shops, reward systems, etc.
They are highly customizable.

Items can also be customized and held by other entities.
(Items are just regular entities with an `itemName` component.)


# entity components:
See `readme_components.md`



# using inventories:
Inventories are automatically synced to serverside/clientside.

Any changes that are made on clientside will be automatically
checked on serverside, and then dispatched to other clients automatically.

Any changes that are made on serverside will be automatically
synced to all clients.


```lua
local inv = ent.inventory

local b = entities.banana()
item.stackSize = 10
print(item.itemName) -- "banana"
```

```lua

inv:set(1, 1, b) 
-- sets slot (1, 1) to banana item.
-- Inventory indexes start at (1,1) and go to (width,height)


b = inv:get(1, 1) 
-- returns the item at location (1, 1), 
-- or nil if there is no item.


inv:open() -- opens inventory for viewing
inv:close() -- closes inventory


inv:swap(other_inv, slot_x, slot_y, other_slot_x, other_slot_y)
-- swaps an item with another inventory
-- Good for stuff like player trading maybe?


item = inv:getHoldingItem()
-- gets the item that is currently being held.
-- This will generally only work for "player" inventories.


num = inv:count("banana") 
-- gets count of the total number of "bananas" in the 

x, y = inv:getFreeSpace() 
-- returns the closest empty space in the inventory


```
 

