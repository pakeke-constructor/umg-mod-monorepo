


## ITEM ENTITY EXAMPLE:
```lua
{
    ent.stackSize -- the current stack size of the item.
    -- if this reaches 0, the item is deleted.

    -- Item specific components:
    maxStackSize = 32; -- Maximum stack size of this item
    
    image = "banana" -- can be shared.
    hidden = true/false -- must not be shared!

    itemName = "..." -- item name


    --===========================================
    -- OPTIONAL VALUES:
    itemDescription = "..." -- item description

    displayItemTooltip = function(self)
        -- Used when you want to display Item info.
    end
    
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


    itemCooldown = 1 -- this item has a 1 second cooldown


    -- How this item should be held.
    -- (If this value is nil, the item cannot be held)
    itemHoldType = 
        "tool"  -- holds in direction of mouse
        "spin"  -- holds in direction of mouse, spinning when used
        "swing" -- holds in direction of mouse, swings when used (think sword)
        "recoil"-- holds in direction of mouse, recoils back when used (think shotgun)
        "above" -- item is above head of entity
        "custom" -- custom positioning, defined by ent.itemHoldUpdate


    -- ONLY USE THIS IF YOU KNOW WHAT YOU ARE DOING!
    itemHoldUpdate = function(item_ent, holder_ent)
        item_ent.x = holder_ent.x
        item_ent.y = holder_ent.y -- see item_holding.lua for examples
    end

    itemHoldDistance = 30 -- holds 30 pixels away (default is 10)
}
```




# INVENTORY COMPONENTS:
```lua

return {
    -- right click to open this chest
    openable = {
        distance = 100; -- default distance that player can open the chest from
        openSound = "chestOpen"; -- default open/close sounds.
        closeSound = "chestClose",
    }

    image = "chest_image",

    init = function(ent, x, y)
        base.initializers.initXY(ent,x,y)

        -- Upon creation, the `inventory` component should be set to a table,
        -- like the following:
        chest.inventory = Inventory({
            width = 6 -- width of inventory slots
            height = 3 -- height

            -- OPTIONAL VALUES:
            hotbar = true -- DST / minecraft like hotbar.
                -- (only works for controllable entities)

            public = true/false -- Whether inv is publically accessible
        })
    end
}
```



### Custom behaviour:
We can customize inventory behaviour with callbacks.

(For example, only allowing access if you are on a specific team)
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

function invCbs:canBeOpenedBy(ent)
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



### shops and stuff
Shops and stuff can be done through the `inventoryUI` component.
(This is a shared component, because it contains functions.)

#### Inventory UI:
```lua


ent.inventoryUI = {
    {
        render = function(ent)
            Slab.Text("we can put UI here!")
            if Slab.Button("enchant") then
                ent:enchantItem()
            end
        end,
        x = 1, -- starts at slot (1,1)
        y = 1,

        width = 3, -- 3 slots wide
        height = 2, -- 2 slots tall

        color = {1,1,1} -- white background color
    },
    {
        ... -- we can render multiple UI components per inventory
    }
}





--[[
    Removing slots from inventories:
    we can use the `inventorySlots` component to enable/disable slots.
]]

-- A 3x3 inventory, with only the central slot enabled:
ent.inventorySlots = {
    {false, false, false},
    {false, true,  false},
    {false, false, false}
}


```


### Holding entities:
If an entity should change it's move animation to face in the direction of
the tool, then simply add the `faceDirection` component to the entity.
(This should be a regular component, don't make it shared!)


For example, here's a basic entity that can hold a gun:
```lua

return {
    image = "blob",

    init = function(ent, x, y)
        base.initializers.initXY(ent,x,y)

        ent.lookX, ent.lookY = 0,0
        -- the X and Y position that this entity is looking at.
        -- (This will also determine the face direction, and the direction
        --   that the tool is facing)

        ent.inventory = items.Inventory({width=1, height=1})

        local gunItem = newGunItem()
        ent.inventory:set(1,1, gunItem)
        ent.inventory:hold(1,1) -- set it to hold slot (1,1)
    end
}


```