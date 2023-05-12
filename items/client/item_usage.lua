

local itemUsage = {}

local itemUsageShared = require("shared.item_usage")




client.on("useItem", function(holder_ent, item, ...)
    if holder_ent and holder_ent.controller == client.getUsername() then
        return -- ignore; we have already called `useItem`, 
        -- since we are the ones who sent the event!
    end
    item:useItem(holder_ent, ...)
    item.itemLastUseTime = base.getGameTime()
end)


local function canUse(holder_ent)
    return holder_ent.controller == client.getUsername()
        and itemUsageShared.canUseHoldItem(holder_ent)
end


local asserter = typecheck.assert("entity")

function itemUsage.useHoldItem(holder_ent, ...)
    asserter(holder_ent)
    local item = holder_ent.inventory and holder_ent.inventory:getHoldItem()
    if canUse(holder_ent) then
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

