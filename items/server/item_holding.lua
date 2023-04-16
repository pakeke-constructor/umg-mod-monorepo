
local itemDrops = require("server.item_drops")


local itemHolding = {}



function itemHolding.releaseItemIfHeld(ent, item_ent)
    if ent.holdItem == item_ent then
        server.broadcast("setInventoryHoldItem", ent, nil)
        ent.holdItem = nil
    end
end




function itemHolding.removeHoldItem(ent)
    if ent.holdItem then
        local item_ent = ent.holdItem
        if not (ent.inventory and ent.inventory:contains(item_ent)) then
            -- then we drop item on the ground
            itemDrops.dropItem(item_ent)
        end
        itemHolding.releaseItemIfHeld(ent, item_ent)
    end
end



function itemHolding.setHoldItem(ent, item_ent)    
    server.broadcast("setInventoryHoldItem", ent, item_ent)

    if not item_ent then
        -- if it's nil, remove any hold item
        itemHolding.removeHoldItem(ent)
        return
    end

    itemDrops.pickupItem(item_ent)
    item_ent.itemBeingHeld = true

    ent.holdItem = item_ent
end


return itemHolding

