
# planning

Plan for inventory:


IDEA:
Represent items as entities.



# ITEM EXAMPLE:
```lua

return {
    "stackSize", -- the current stack size of the item.
    -- if this reaches 0, the item is deleted.

    "x", "y",
    "hidden",

    -- Item specific components:
    maxStackSize = 32; -- Maximum stack size of this item
    
    image = "banana" -- can be shared.
    hidden = true/false -- must not be shared!

    itemName = "..." -- item name

    -- OPTIONAL VALUES:
    itemDescription = "..." -- item description
    
    useItem = function(self, holderEnt)
        -- Called when item is used by `holderEnt`
    end

    dropItem = function(self, holderEnt)
        -- Called when item is dropped by `holderEnt`
    end

    collectItem = function(self, holderEnt)
        -- Called when item is picked up by `holderEnt`
    end

}
```




# INVENTORY EXAMPLE:
```lua

-- Component definition
ent.inventory = {
    width = 6 -- width of inventory slots
    height = 3 -- height
    hotbar = true -- DST / minecraft like hotbar.
        -- (Is always open if on a control entity.)

    private = true/false -- This means that only the owner can open this
    -- inventory
}




```lua

InventoryObject = {
    width = 6;
    height = 3;
    hotbar = true/false

    inventory = {
        [1] = banana_entity -- remember the banana item is stackable!
        -- so there could be multiple bananas encased in `banana_entity`.
        [3] = apple_entity

        [7] = sword_entity -- Sword entity is NOT stackable.
        -- Therefore there is only one
    }
}


-- Regular methods:
inventory:open() -- opens inventory

inventory:close()

inventory:count(item)

inventory:remove(item, amount) -- removes from any slot

inventory:get(x, y)

inventory:add(item, amount) -- adds to any slot

inventory:has(item, amount)

inventory:swap(other_inventory, self_x, self_y, other_x, other_y)

x,y = inventory:getSpace() -- gets a free space in the inventory.
-- (returns nil if full.)

```


# server <--> client  events
## Server --> Client
`setInventoryItem( ent, x, y, item_ent )`
Server --> Client ::: sets an inventory item

`dropInventoryItem(item, x, y)`
Server --> Client ::: drops item at x,y

`pickUpInventoryItem(item)` 
Server --> Client ::: removes item from the group

`setInventoryItemStackSize(item, stackSize)`
Server --> Client ::: sets stack size for inventory item



## Client --> Server
`trySwapInventoryItem( ent, other_ent, self_x, `
                        `self_y, other_x, other_y )`
Client --> Server ::: tries to swap an inventory item with another inventory

`tryDropInventoryItem( ent, x, y )`
Client --> Server ::: drops inventory item at x,y for entity

`tryMoveInventoryItem( ent, other_ent, self_x, self_y, other_x, `
                        `other_y, count=ALL )`
Client --> Server ::: attempts to move an inventory item


### actions planning:
Player moves item in their own inventory:
Generates two `setInventoryItem` calls, one for deletion, one for addition

Player drops inventory item:
Generates `setInventoryItem` nil call, and sets `item.hidden = true`,
and `item.itemBeingHeld = false`




# Item holding and usage:
```lua

ent.holdItem = my_item_ent
-- ent is now holding `my_item_ent`

my_item_ent.itemOwner = ent
-- this should be set to ensure stuff works properly



```


### Picking up items:
```lua

ent.canPickUp = true
-- Now this entity can pick up items

```

