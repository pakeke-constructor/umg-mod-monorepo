


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




canUseItem = function(self, holderEnt, x, y)
    -- returns true/false, depending on whether the player can use the item or not
end

useItem = function(self, holderEnt)
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

itemHoldImage = "custom_image" -- an optional custom image for holding


```


