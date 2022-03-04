
# planning

Plan for inventory:


IDEA:
Represent items as entities.

But, when items are STACKED in the inventory, they are represented as 
entity id names.
(Strings are interned so they take up not much memory.)

When items are not stacked, the entity can simply be put there.
This allows you to do complex stuff, like assign special tags to items,
like durability, enchantments, etc.




# ITEM ANATOMY:
```lua
-- item entity
return {

    maxStackSize = 32; -- stack size of this item
    stackSize
    image = "banana"

    itemName = "..." -- item name

    itemDescription = "..." -- item description
    
    itemNameFancy = "dfdf"
    itemDescriptionFancy = "..." -- coloured / bold / italic description.
    -- If this exists, this overrides `description`!

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

^^^^ ISSUE:
What happens if the item is stacked?
There will be no entity to call upon!






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
    hotbar = true -- DST / minecraft like hotbar
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


--[[
==========================================
    INVENTORY FUNCTIONS
==========================================
]]

-- Callbacks:
function inventory:canRemove(x, y)
    return true/false
end

function inventory:canAdd(x, y)
    return true/false
end

function inventory:onAdd(x, y, item_ent)
    ...
end

function inventory:onRemove(x, y, item_ent)
    ...
end



-- Regular methods:
inventory:open() -- opens inventory

inventory:close()


inventory:count(item)

inventory:remove(item, amount)

invventory:get()

inventory:add(item, amount)

inventory:has(item, amount)



```

### shops and stuff




