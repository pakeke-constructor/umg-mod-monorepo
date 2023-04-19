
--[[

Entities that can pick up items off the ground have a `canPickUpItems` component.

]]



local pickUpGroup = umg.group("x", "y", "canPickUpItems", "inventory")

local groundItemGroup = umg.group("x", "y", "groundItem", "inventory")


local CHUNK_SIZE = 100
local groundItemPartition = base.Partition(CHUNK_SIZE)

local PICKUP_DISTANCE = 10

local PICKUP_DELAY_TIME = 1







groundItemGroup:onAdded(function(e)
    groundItemPartition:addEntity(e)
    e.groundItemSpawnTime = base.getGameTime()
end)


groundItemGroup:onRemoved(function(e)
    groundItemPartition:removeEntity(e)
end)




local function canBePickedUp(dist, best_dist, item)
    if dist > PICKUP_DISTANCE or dist > best_dist then 
        -- we want to try and pick up the closest item.
        -- if there is an item that is closer, ignore it
        return
    end

    if item._item_last_holdtime then
        local time = base.getGameTime() - item._item_last_holdtime
        if time < PICKUP_DELAY_TIME then
            return
        end
    end

    return true
end



local function pickup(pickupEnt, groundItemEnt)
    
end



local function tryPickUp(ent, picked)
    local ix, iy
    local best_ent
    local combine = false -- whether stacks are combined or not
    local best_dist = math.huge

    local free_ix, free_iy = ent.inventory:getFreeSlot()
    for _, groundItem in groundItemPartition:iterator(ent.x, ent.y) do
        if (not picked[groundItem]) then 
            -- then the item is on the ground
            local d = math.distance(ent, groundItem)
            if canBePickedUp(d, best_dist, groundItem) then
                ix, iy = ent.inventory:getFreeSlotFor(groundItem)
                if ix then
                    -- first, we try to put into existing slot
                    combine = true
                    best_dist = d
                    best_ent = groundItem
                elseif (not combine) and free_ix then
                    -- we only want to pick up an item into a free spot,
                    -- if there are no opportunities to combine stacks.
                    best_dist = d
                    best_ent = groundItem
                end
            end
        end
    end

    if best_ent then
        -- pick up this groundItem
        if combine then
            -- we combine stacks
            local item = ent.inventory:get(ix, iy)
            item.stackSize = (item.stackSize or 1) + (best_ent.stackSize or 1)
            best_ent:delete()
        else
            -- we just set normally
            ent.inventory:set(free_ix, free_iy, best_ent)
        end
        picked[best_ent] = true
        pickup(best_ent)
    end
end



local function updatePartition()
    -- TODO: bugfix this!!!! there could easily be issues
    for _, ent in ipairs(pickUpGroup) do
        if ent.itemBeingHeld then
            if groundItemPartition:contains(ent) then
                groundItemPartition:removeEntity(ent)
            end
        else
            groundItemPartition:updateEntity(ent)
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
    updatePartition()

    local picked = {}
    for _, ent in ipairs(pickUpGroup) do
        if ent.inventory then
            tryPickUp(ent, picked)
        end 
    end
end)


