

local common = {}



function common.getHoldSlot(ent)
    local holdItem = ent.holdItem
    if (holdItem.slotX and holdItem.slotY) then
        return ent.holdItemX, ent.holdItemY
    end
end



function common.getHoldItem(ent)
    if not ent.inventory then
        return nil
    end

    local holdItem = ent.holdItem
    if umg.exists(holdItem) then
        -- its an entity
        return holdItem
    end

    local slotX, slotY = common.getHoldSlot(ent)
    if slotX then
        return ent.inventory:get(slotX, slotY)
    end
end




local DEFAULT_HOLD_DISTANCE = 10


function common.getHoldDistance(itemEnt, holderEnt)
    local dis1 = itemEnt.itemHoldDistance or DEFAULT_HOLD_DISTANCE
    local dis2 = holderEnt.itemHoldDistance or DEFAULT_HOLD_DISTANCE
    return dis1 + dis2
end





return common
