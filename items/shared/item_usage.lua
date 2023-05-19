

local itemUsageShared = {}




local DEFAULT_ITEM_COOLDOWN = 0.2


local function getHoldItem(ent)
    local inv = ent.inventory
    if inv then
        local item = inv:getHoldItem()
        return umg.exists(item) and item
    end
end



function itemUsageShared.canUseHoldItem(holder_ent, ...)
    if (not umg.exists(holder_ent)) or (not getHoldItem(holder_ent)) then
        return false
    end

    local item = getHoldItem(holder_ent)
    if not item.useItem then
        return false
    end

    local time = base.getGameTime()
    local time_since_use = time - (item.itemLastUseTime or 0)
    local cooldown = (item.itemCooldown or DEFAULT_ITEM_COOLDOWN)
    if math.abs(time_since_use) < cooldown then
        return false
    end

    local OR = base.operators.OR
    local usageBlocked = umg.ask("itemUsageBlocked", OR, holder_ent, item)
    if usageBlocked then
        return false
    end

    if item.canUseItem ~= nil then
        if type(item.canUseItem) == "function" then
            return item:canUseItem(holder_ent, ...) -- return callback value
        else
            return item.canUseItem -- it's probably a boolean
        end
    end

    return true
    -- assume that it can be used.
end




return itemUsageShared
