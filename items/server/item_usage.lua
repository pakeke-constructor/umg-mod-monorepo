

local itemUsage = {}

local itemUsageShared = require("shared.item_usage")





local function getHoldItem(ent)
    local inv = ent.inventory
    if inv then
        local item = inv:getHoldItem()
        return umg.exists(item) and item
    end
end



local function useItemDeny(item, holder_ent, ...)
    item:useItemDeny(holder_ent, ...)
    umg.call("items:useItemDeny", holder_ent, item, ...)
end



function itemUsage.useHoldItem(holder_ent, ...)
    local item = getHoldItem(holder_ent)
    if item then
        if itemUsageShared.canUseHoldItem(holder_ent) then
            itemUsage.useItemDirectly(holder_ent, item, ...)
        else
            useItemDeny(item, holder_ent, ...)
        end
    end
end



local asserterDirect = typecheck.assert("entity?", "entity")

function itemUsage.useItemDirectly(holder_ent, item, ...)
    asserterDirect(holder_ent, item)
    -- holder_ent could be nil here
    if type(item.useItem) == "function" then
        item:useItem(holder_ent or false, ...)
    end
    umg.call("items:useItem", holder_ent, item, ...)
    server.broadcast("useItem", holder_ent, item, ...)
    item.itemLastUseTime = state.getGameTime()
end



local sf = sync.filters

server.on("useItem", {
    arguments = {sf.entity},
    handler = function(sender, holder_ent, ...)
        if not umg.exists(holder_ent) then return end
        if not getHoldItem(holder_ent) then return end
        if holder_ent.controller ~= sender then return end

        itemUsage.useHoldItem(holder_ent, ...)
    end
})




return itemUsage

