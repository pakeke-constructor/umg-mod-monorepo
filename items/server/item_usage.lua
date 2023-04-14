

local itemUsage = {}

local DEFAULT_ITEM_COOLDOWN = 0.01



function itemUsage.canUseHoldItem(holder_ent, ...)
    if (not umg.exists(holder_ent)) or (not umg.exists(holder_ent.holdItem)) then
        return false
    end

    local item = holder_ent.holdItem
    if not item.useItem then
        return false
    end

    local time = base.getGameTime()
    local time_since_use = time - (item.item_lastUseTime or 0)
    local cooldown = (item.itemCooldown or DEFAULT_ITEM_COOLDOWN)
    if math.abs(time_since_use) < cooldown then
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



local function useItemDeny(item, holder_ent, ...)
    item:useItemDeny(holder_ent, ...)
    umg.call("useItemDeny", holder_ent, item, ...)
end



function itemUsage.useHoldItem(holder_ent, ...)
    local item = holder_ent.holdItem
    if itemUsage.canUseHoldItem(holder_ent) then
        itemUsage.useItemDirectly(holder_ent, item, ...)
    elseif item and item.useItemDeny then
        useItemDeny(item, holder_ent, ...)
    end
end



local asserterDirect = base.typecheck.assert("entity?", "entity")

function itemUsage.useItemDirectly(holder_ent, item, ...)
    asserterDirect(holder_ent, item)
    -- holder_ent could be nil here
    if type(item.useItem) == "function" then
        item:useItem(holder_ent or false, ...)
    end
    umg.call("useItem", holder_ent, item, ...)
    server.broadcast("useItem", holder_ent, item, ...)
    item.item_lastUseTime = base.getGameTime()
end




server.on("useItem", function(username, holder_ent, ...)
    if not umg.exists(holder_ent) then return end
    if not umg.exists(holder_ent.holdItem) then return end
    if holder_ent.controller ~= username then return end

    itemUsage.useHoldItem(holder_ent, ...)
end)




return itemUsage

