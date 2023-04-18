
--[[

Entities that can pick up items off the ground have a `canPickUpItems` component.

]]



local pickUpGroup = umg.group("x", "y", "canPickUpItems")

local itemGroup = umg.group("x", "y", "itemName")




local currentTime = love.timer.getTime()




itemGroup:onAdded(function(e)
    if not e.itemBeingHeld then
        itemDrops.itemPartition:addEntity(e)
    end
end)


itemGroup:onRemoved(function(e)
    itemDrops.itemPartition:removeEntity(e)
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




local function tryPickUpInventory(ent, picked)
    --[[
        tries to pick up an item via `ent.inventory` component
    ]]
    local ix, iy
    local best_item
    local combine = false -- whether stacks are combined or not
    local best_dist = math.huge

    local free_ix, free_iy = ent.inventory:getFreeSpace()
    for _, item in itemDrops.itemPartition:iterator(ent.x, ent.y) do
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



local function updatePartition()
    -- TODO: bugfix this!!!! there could easily be issues
    for _, ent in ipairs(pickUpGroup) do
        if ent.itemBeingHeld then
            if itemDrops.itemPartition:contains(ent) then
                itemDrops.itemPartition:removeEntity(ent)
            end
        else
            itemDrops.itemPartition:updateEntity(ent)
        end
    end
end



local ct = 0
local LOOP_CT = 8

umg.on("@tick", function(dt)
    -- This function runs once every LOOP_CT frames:
    ct = ct + 1
    if ct < LOOP_CT then
        return -- return early
    else
        ct = 0 -- else, we run function
    end
    -- ==========
    currentTime = base.getGameTime()

    updatePartition()

    local picked = {}
    for _, ent in ipairs(pickUpGroup) do
        if ent:isRegular("inventory") and ent.inventory then
            tryPickUpInventory(ent, picked)
        end 
        if ent:isRegular("holdItem") then
            tryPickUpHold(ent, picked)
        end
    end
end)


