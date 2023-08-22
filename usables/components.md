

```lua



ent.holdItem = {
    -- the slot in the inventory:
    slotX = 1,
    slotY = 2
    
}

-- Or, alternatively,

ent.holdItem = itemEnt
-- ^^^ this way is much less robust!!!
-- Only use this if the item isn't expected to move anywhere.
-- (eg. for enemies that can only hold one item type)


```


