


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


    --===========================================
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


    --===========================================
    -- OPTIONAL: USING ITEMS: 
    -- Used for stuff like consumables, weapons, tools, etc.

    canUseItem = function(self, holderEnt, ...)
        -- returns true/false, depending on whether the 
        -- item can be used or not.
        -- `...` is some arbitrary arguments, passed by `items.useItem(ent)`
    end

    useItem = function(self, holderEnt, ...)
        -- Called when `holderEnt` attempts to use this item.

        -- The return value for this function is how many items should be deleted
        -- after use. (default is 0.)
    end


    -- How the player should hold the item.
    -- (If this value is nil, the item cannot be held)
    itemHoldType = 
    "place" -- shows an preview for placing an item
    "tool"  -- holds in direction of mouse
    "spin"  -- holds in direction of mouse, spins around when used
    "swing" -- holds in direction of mouse, swings when used (think sword)
    "recoil"-- holds in direction of mouse, recoils back when used (think shotgun)
    "above" -- item is above player's head

    itemHoldImage = "custom_image"
    -- an optional custom image for item holding
}
```




# INVENTORY EXAMPLE:
```lua

-- Chest entity
return {
    "inventory",

    "x", "y",
    image = "chest_image"
}
```
```lua

local chest = entities.chest()

chest.inventory = {
    width = 6 -- width of inventory slots
    height = 3 -- height
    hotbar = true -- DST / minecraft like hotbar.
        -- (Is always open if on a control entity.)

    private = true/false -- This means that only the owner can open this
    -- inventory
}

```





### PLAYER:

moveAnimations on the player can be changed to make the player point
in the direction of the mouse.

This component is called `holdAnimation`, and it only works on player entities.
```lua

--[[
    holdAnimation is the same as base-mod moveAnimation, 
    except the entity will face in the direction of the mouse.
    This should be used for players that hold tools.
    (If the player isn't holding a tool, then just face in the direction of movement.)
]]
ent.holdAnimation = {
    up = {"up1", "up2", ...},
    down = ...,  left = ..., right = ...
    speed = 3;

    activation = 10 -- holdAnimation activates when entity is travelling at 
    -- at least 10 units per second.
}



```


