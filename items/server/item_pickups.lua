
--[[

Entities that can pick up items off the ground have a `canPickUp` component.

]]


local itemDrops = require("server.item_drops")


local pickUpGroup = umg.group("x", "y", "canPickUp")

local itemGroup = umg.group("x", "y", "itemName")




local currentTime = love.timer.getTime()




itemGroup:onAdded(function(e)
    itemDrops.itemPartition:add(e)
end)


itemGroup:onRemoved(function(e)
    itemDrops.itemPartition:remove(e)
end)



local function canBePickedUp(dist, best_dist, item)
    if dist > itemDrops.PICKUP_DISTANCE or dist > best_dist then 
        -- we want to try and pick up the closest item.
        -- if there is an item that is closer, ignore it
        return
    end

    if item._item_last_holdtime then
        local time = currentTime - item._item_last_holdtime
        if time < itemDrops.PICKUP_DELAY_TIME then
            return
        end
    end

    return true
end





local function tryPickUpHold(ent, picked)
    --[[
        tries to pick up an item via `ent.holdItem` component
    ]]
    if umg.exists(ent.holdItem) then
        return
    end

    local best_item
    local best_dist = math.huge

    for item in itemDrops.itemPartition:foreach(ent.x, ent.y) do
        if item.itemHoldType and (not item.itemBeingHeld) and (not picked[item]) then 
            -- then the item is on the ground
            local d = math.distance(ent, item)
            if canBePickedUp(d, best_dist, item) then
                best_dist = d
                best_item = item
            end
        end
    end
    if best_item then
        ent.holdItem = best_item
        server.broadcast("setInventoryHoldItem", ent, best_item)
    end
end



local function tryPickUpInventory(ent, picked)
    --[[
        tries to pick up an item via `ent.inventory` component
    ]]
    local ix, iy
    local best_item
    local combine = false -- whether stacks are combined or not
    local best_dist = math.huge

    local free_ix, free_iy = ent.inventory:getFreeSpace()
    for item in itemDrops.itemPartition:foreach(ent.x, ent.y) do
        if (not item.itemBeingHeld) and (not picked[item]) then 
            -- then the item is on the ground
            local d = math.distance(ent, item)
            if canBePickedUp(d, best_dist, item) then
                ix, iy = ent.inventory:getFreeSpaceFor(item)
                if ix then
                    -- first, we try to put into existing slot
                    combine = true
                    best_dist = d
                    best_item = item
                elseif (not combine) and free_ix then
                    -- we only want to pick up an item into a free spot,
                    -- if there are no opportunities to combine stacks.
                    best_dist = d
                    best_item = item
                end
            end
        end
    end

    if best_item then
        -- pick up this item.
        if combine then
            -- we combine stacks
            local item = ent.inventory:get(ix, iy)
            item.stackSize = (item.stackSize or 1) + (best_item.stackSize or 1)
            best_item:delete()
        else
            -- we just set normally
            ent.inventory:set(free_ix, free_iy, best_item)
        end
        picked[best_item] = true
        itemDrops.pickupItem(best_item)
    end
end




local ct = 0
local LOOP_CT = 8

umg.on("gameUpdate", function(dt)
    -- This function runes once every LOOP_CT frames:
    ct = ct + 1
    if ct < LOOP_CT then
        return -- return early
    else
        ct = 0 -- else, we run function
    end
    -- ==========
    currentTime = base.getGameTime()

    local picked = {}
    itemDrops.itemPartition:update(dt)
    for _, ent in ipairs(pickUpGroup) do
        if ent:isRegular("inventory") and ent.inventory then
            tryPickUpInventory(ent, picked)
        end 
        if ent:isRegular("holdItem") then
            tryPickUpHold(ent, picked)
        end
    end
end)

