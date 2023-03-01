

local itemUsage = {}




client.on("useItem", function(holder_ent, item, ...)
    if holder_ent and holder_ent.controller == client.getUsername() then
        return -- ignore; we have already called `useItem`, 
        -- since we are the ones who sent the event!
    end
    item:useItem(holder_ent, ...)
    item.item_lastUseTime = base.getGameTime()
end)



local DEFAULT_ITEM_COOLDOWN = 0.01


function itemUsage.canUseHoldItem(holder_ent, ...)
    if (not umg.exists(holder_ent)) or (not umg.exists(holder_ent.holdItem)) then
        return false
    end
    if holder_ent.controller ~= client.getUsername() then
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




local asserter = base.typecheck.assert("entity")

function itemUsage.useHoldItem(holder_ent, ...)
    asserter(holder_ent)
    local item = holder_ent.holdItem
    if itemUsage.canUseHoldItem(holder_ent) then
        asserter(holder_ent)
        client.send("useItem", holder_ent, ...)
        umg.call("useItem", holder_ent, item, ...)
        if type(item.useItem) == "function" then
            item:useItem(holder_ent or false, ...)
        end
        item.item_lastUseTime = base.getGameTime()
    elseif item and item.useItemDeny then
        item:useItemDeny(holder_ent, ...)
    end
end


return itemUsage

