

local common = {}



function common.getHoldItem(ent)
    local holdItem = ent.holdItem
    if umg.exists(holdItem) then
        -- its an entity
        return holdItem
    end
end




local DEFAULT_HOLD_DISTANCE = 10


function common.getHoldDistance(itemEnt, holderEnt)
    local dis1 = itemEnt.itemHoldDistance or DEFAULT_HOLD_DISTANCE
    local dis2 = holderEnt.itemHoldDistance or DEFAULT_HOLD_DISTANCE
    return dis1 + dis2
end




return common
