

local holdingEnts = group("holdItem")


local function removeHoldItem(ent)
    if ent.holdItem then
        local item_ent = ent.holdItem
        if not (ent.inventory and ent.inventory:contains(item_ent)) then
            -- then we drop item on the ground
            dropItem(item_ent)
        end
    end
    ent.holdItem = nil
end



local function setHoldItem(ent, item_ent)
    if not item_ent then
        -- if it's nil, remove any hold item
        removeHoldItem(ent)
    end

    if item_ent.itemBeingHeld then
        --
    end
    item_ent.itemBeingHeld = true
end




holdingEnts:onAdded(function(ent)
    if ent.holdItem then
        local success = setHoldItem(ent, ent.holdItem)
        assert(success, "Failed to setHoldItem for entity")
    end
end)



