
# inventory mod

This mod adds items and Inventories.

With inventories, you can make shops, reward systems, etc.
They are highly customizable.

Items can also be customized and held by other entities.



# entity components:
```lua
-- Basic inventory component usage:
inventory = {
    width = 6; -- width / height of inventory, in slots
    height = 6;
    hotbar = true -- hotbar shows up on player side!
}




-- Item components
-- Item stacks are just entities.
-- Here are the main components:

itemName = "banana" -- display name:

itemDescription = "A long yellow fruit"

maxStackSize = 64 -- The maximum size this item can stack to.


stackSize = 31 -- how much this item is stacked. (Must NOT be shared!)



```


## advanced components:
```lua

-- Advanced components for items:
dropItem = function(self, holderEnt)
    -- Called when item `self` is dropped by `holderEnt`
end

collectItem = function(self, holderEnt)
    -- Called when item `self` is picked up by `holderEnt`
end



itemDescriptionFancy = "..." -- colored / bold / italic description
itemNameFancy = "..."
-- TODO ^^^ these aren't implemented yet




```
