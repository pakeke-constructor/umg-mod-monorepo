
local common = require("shared.common")


local holdingEnts = group("holdItem")


local itemHolding = {}

function itemHolding.removeHoldItem(ent)
    if ent.holdItem then
        local item_ent = ent.holdItem
        if not (ent.inventory and ent.inventory:contains(item_ent)) then
            -- then we drop item on the ground
            common.dropItem(item_ent)
        end
    end
    ent.holdItem = nil
end


function itemHolding.setHoldItem(ent, item_ent)
    if not item_ent then
        -- if it's nil, remove any hold item
        itemHolding.removeHoldItem(ent)
    end

    common.pickUpItem(item_ent)
    item_ent.itemBeingHeld = true
end




holdingEnts:onAdded(function(ent)
    if ent.holdItem then
        local success = itemHolding.setHoldItem(ent, ent.holdItem)
        assert(success, "Failed to setHoldItem for entity")
    end
end)



return itemHolding
