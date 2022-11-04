
--[[

Entities that can pick up items off the ground have a `canPickUp` component.

]]


local common = require("shared.common")


local pickUpEntities = group("x", "y", "canPickUp")

local itemEntities = group("x", "y", "itemName")




local currentTime = timer.getTime()




itemEntities:onAdded(function(e)
    if not e:isRegular("hidden") then
        error("Item entities must have a `hidden` regular component.\nNot the case for " .. e:type())
    end
    if not e:isRegular("itemBeingHeld") then
        error("Item entities must have a `itemBeingHeld` regular component.\nNot the case for " .. e:type())
    end
    common.itemPartition:add(e)
end)


itemEntities:onRemoved(function(e)
    common.itemPartition:remove(e)
end)



local function canBePickedUp(dist, best_dist, item)
    if dist > common.PICKUP_DISTANCE or dist > best_dist then 
        -- we want to try and pick up the closest item.
        -- if there is an item that is closer, ignore it
        return
    end

    if item._item_last_holdtime then
        local time = currentTime - item._item_last_holdtime
        if time < common.PICKUP_DELAY_TIME then
            return
        end
    end

    return true
end




local function canPickUpAnItem(ent)
    if not ent.canPickUp then
        return false
    end
    if ent.inventory then
        return true
    elseif ent:isRegular("holdItem") and (not exists(ent.holdItem)) then
        return true
    end
end



local function tryPickUpHold(ent, picked)
    --[[
        tries to pick up an item via `ent.holdItem` component
    ]]
    if exists(ent.holdItem) then
        return
    end

    local best_item
    local best_dist = math.huge

    for item in common.itemPartition:foreach(ent.x, ent.y) do
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
    for item in common.itemPartition:foreach(ent.x, ent.y) do
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
        common.pickupItem(best_item)
    end
end




local ct = 0
local LOOP_CT = 8

on("gameUpdate", function(dt)
    -- This function runes once every LOOP_CT frames:
    ct = ct + 1
    if ct < LOOP_CT then
        return -- return early
    else
        ct = 0 -- else, we run function
    end
    -- ==========

    local picked = {}
    common.itemPartition:update(dt)
    for _, ent in ipairs(pickUpEntities) do
        if canPickUpAnItem(ent) then
            if ent:isRegular("inventory") then
                tryPickUpInventory(ent, picked)
            end 
            if ent:isRegular("holdItem") then
                tryPickUpHold(ent, picked)
            end
        end
    end
end)

