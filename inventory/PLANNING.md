
# planning

Plan for inventory:


IDEA:
Represent items as entities.



# ITEM ANATOMY:
```lua
-- item entity
return {

    -- Item specific components:
    maxStackSize = 32; -- Maximum stack size of this item
    stackSize = 1 -- 1 item here. If this is 0, the entity should be deleted.
    
    image = "banana" -- can be shared.
    hidden = true/false -- must not be shared!

    itemName = "..." -- item name


    -- OPTIONAL COMPONENTS:

    -- TODO: Support colours, bold + italics with display names and descriptions.
    itemDisplayName = "..." -- item display name

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




# INVENTORY ANATOMY:
```lua

local sword_entity = sword({damage = 10})
-- maxStackSize = 1, so no stack.

local banana_entity = banana()
banana_entity.stackSize = 10 -- 10 bananas

local apple_entity = apple()
apple_entity.stackSize = 5 -- 5 apples


-- Component definition
ent.inventory = {
    width = 6 -- width of inventory slots
    height = 3 -- height
    hotbar = true -- DST / minecraft like hotbar.
        -- (Is always open if on a control entity.)

    private = true/false -- This means that only the owner can open this
    -- inventory
}



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
Generates `setInventoryItem` nil call, and sets `item.hidden = true`




### shops and stuff
Shops and stuff can be done through `inventoryCallbacks` component.
(This is a shared component, because it contains functions.)


```lua

local invCbs = ent.inventoryCallbacks

-- Callbacks:
function invCbs:canRemove(item, x, y)
    -- `self` is the inventory object
    return true/false
end

function invCbs:canAdd(item, x, y)
    -- `self` is the inventory object
    return true/false
end

function invCbs:canOpen(ent)
    -- `self` is the inventory object
    -- `ent` is the player that is trying to open the inventory
    return true/false
end





function invCbs:onAdd(item, x, y)
    -- `self` is the inventory object
    ...
end

function invCbs:onRemove(item_ent, x, y)
    -- `self` is the inventory object
    ...
end

function invCbs:onOpen(ent)
    -- `self` is the inventory object
    -- `ent` is the player that is trying to open the inventory
    ...
end



```




