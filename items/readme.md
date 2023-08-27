
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

b = inv:get(1, 1) 
-- returns the item at slot (1, 1), 
-- or nil if there is no item.


inv:open() -- opens inventory for viewing
inv:close() -- closes inventory


num = inv:count("banana") 
-- gets count of the total number of "bananas" in the 

slotX, slotY = inv:getFreeSlot() 
-- returns the closest empty slot in the inventory


```
 

