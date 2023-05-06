

local itemUsage = {}




client.on("useItem", function(holder_ent, item, ...)
    if holder_ent and holder_ent.controller == client.getUsername() then
        return -- ignore; we have already called `useItem`, 
        -- since we are the ones who sent the event!
    end
    item:useItem(holder_ent, ...)
    item.itemLastUseTime = base.getGameTime()
end)



local DEFAULT_ITEM_COOLDOWN = 0.01


function itemUsage.canUseHoldItem(holder_ent, ...)
    if not umg.exists(holder_ent) then
        return false
    end
    if holder_ent.controller ~= client.getUsername() then
        return false
    end

    if not holder_ent.inventory then
        return false
    end

    local item = holder_ent.inventory:getHoldItem()
    if (not umg.exists(item)) or (not item.useItem) then
        return false
    end

    local time = base.getGameTime()
    local time_since_use = time - (item.itemLastUseTime or 0)
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




local asserter = typecheck.assert("entity")

function itemUsage.useHoldItem(holder_ent, ...)
    asserter(holder_ent)
    local item = holder_ent.inventory and holder_ent.inventory:getHoldItem()
    if itemUsage.canUseHoldItem(holder_ent) then
        asserter(holder_ent)
        client.send("useItem", holder_ent, ...)
        umg.call("useItem", holder_ent, item, ...)
        if type(item.useItem) == "function" then
            item:useItem(holder_ent or false, ...)
        end
        item.itemLastUseTime = base.getGameTime()
    elseif item and item.useItemDeny then
        item:useItemDeny(holder_ent, ...)
    end
end


return itemUsage

