
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

itemName = "banana" -- item name must be unique!

itemDescription = "A long yellow fruit"

maxStackSize = 64 -- The maximum size this item can stack to.

useItem = function(self, holderEnt)
    -- Called when `holderEnt` attempts to use this item.

    -- The return value for this function is how many items should be deleted
    -- after use. (default is 0.)
end


stackSize = 31 -- how much this item is stacked. (Must NOT be shared!)


```


## advanced components:
```lua

-- Advanced components for items:
dropItem = function(self, holderEnt)
    -- Called when `self` is dropped by `holderEnt`
end

collectItem = function(self, holderEnt)
    -- Called when `self` is picked up by `holderEnt`
end


itemDescriptionFancy = "..." -- colored / bold / italic description
-- TODO ^^^ this isn't implemented yet
itemNameFancy = "..."




```
