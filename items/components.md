


## ITEM ENTITY EXAMPLE:
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
        -- `...` is some arbitrary arguments, passed by 
        --    item:use(...)
        -- CALLED ON BOTH SERVERSIDE __AND__ CLIENTSIDE!
    end

    useItem = function(self, holderEnt, ...)
        -- Called when `holderEnt` attempts to use this item.

        -- The return value for this function is how many items should be deleted
        -- after use. (default is 0.)
        -- `...` is some arbitrary arguments, passed by 
        --    item:use(...)
        -- CALLED ON BOTH SERVERSIDE __AND__ CLIENTSIDE!
    end

    useItemDeny = function(self, holderEnt, ...)
        -- Called when an item is tried to be used, but is denied.
        -- (This will only called on the client that did 
        --   item:use(...) unsuccessfully.)
    end


    -- How the player should hold the item.
    -- (If this value is nil, the item cannot be held)
    itemHoldType = 
    "place" -- shows an preview for placing an entity
    "tool"  -- holds in direction of mouse
    "spin"  -- holds in direction of mouse, spins around when used
    "swing" -- holds in direction of mouse, swings when used (think sword)
    "recoil"-- holds in direction of mouse, recoils back when used (think shotgun)
    "above" -- item is above player's head
    
    itemHoldImage = "custom_image"
    -- an optional custom image for item holding


    placeGridSize = 20 
    -- the size of the grid to snap to when using `place` itemHoldType

}
```




# INVENTORY COMPONENTS:
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



-- Upon creation, the `inventory` component should be set to a table,
-- like the following:
chest.inventory = {
    width = 6 -- width of inventory slots
    height = 3 -- height
    hotbar = true -- DST / minecraft like hotbar.
        -- (Is always open if on a control entity.)

    private = true/false -- This means that only the owner can open this
    -- inventory
}
-- if this isn't done, the client will crash.

```



### shops and stuff
Shops and stuff can be done through `inventoryCallbacks` component.
(This is a shared component, because it contains functions.)

Also, the `inventoryButtons` component can be used to add buttons to inventory

```lua

local invCbs = ent.inventoryCallbacks


-- Callbacks:


-- Used to draw overlays and stuff, etc.
function invCbs:draw()
    ... -- called when the inventory interface is drawn.
    -- `self` is the inventory object.
end


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


function invCbs:slotExists(x, y)
    -- `self` is the inventory object
    -- returns `true` if the slot at x,y exists, false if it doesn't exist.
    -- This is useful for implementing special interfaces, such as crafting.
    
    -- If an (x,y) slot doesn't exist, it isn't drawn, and is not able to contain items.
    -- (If this callback isn't specified, then it's assumed that all slots exist.)
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


#### Inventory buttons:
```lua


ent.inventoryButtons = {
    -- This is a button at position (1,2) in the inventory
    [{1, 2}] = {
        onClick = function(self)
            -- `self` is the inventory object
            -- This is only called on the client-side.
        end;
        image = "button_image1" -- image of the button
    };

    [{3, 4}] = {
        ... -- another button at position (3,4)
    }
}


```


### Holding entities:
If an entity should change it's move animation to face in the direction of
the tool, then simply add the `faceDirection` component to the entity.
(This should be a regular component, don't make it shared!)

