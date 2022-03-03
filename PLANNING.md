
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

    stackSize = 32; -- stack size of this item
    image = "banana"
    
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
-- stack_size = 1

local banana_entity = banana()

local apple_entity = apple()


ent.inventory = {
    [banana_entity] = 5
    -- this inventory has 5 bananas.
    [apple_entity] = 203
    -- and 203 apples
    -- (assume stack size for apples is 50)

    [sword_entity] = 1 -- sword_entity max stack size is 1,
    -- therefore there can only be one per slot.

    
    -- type pointers:
    -- These are typenames that point to the entities inside of the
    -- inventory.   (managed internally)
    ["pakeke-constructor.test:sword"] = sword_entity;
    ["pakeke-constructor.test:banana"] = banana_entity;
    ["pakeke-constructor.test:apple"] = apple_entity;

    size = 209
    slots_used = 7 -- 5 slots for apples, 1 for bananas, 1 for sword.
    slots_width = 4
    slots_height = 4
}


--[[
==========================================
    INVENTORY FUNCTIONS
==========================================
]]

function inventory:canRemove(item, amount)
    return true/false
end

function inventory:canAdd(item, amount)
    return true/false
end

function inventory:onAdd(item, amount)
    ...
end

function inventory:onRemove(item, amount)
    ...
end


function inventory:count(item)
    return self[item] -- gets the amount of `item` in inventory
end



function inventory.remove(item, amount)
end

function inventory.add(item, amount)
end

```

### shops and stuff


