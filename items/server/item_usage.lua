


local usable_items = group("itemName", "useItem")


local function useMethod(item, ...)
    -- item.ownerInventory is set by the inventory.
    -- If this item is not in any inventory, then it's nil
    local holder_ent = item.ownerInventory and item.ownerInventory.owner
    if item:canUse(...) then
        server.broadcast("useItem", item, holder_ent, ...)
        item:useItem(holder_ent, ...)
    else
        item:useItemDeny(holder_ent, ...)
    end
end


local function canUseMethod(item, ...)
    if item.canUseItem ~= nil then
        if type(item.canUseItem) == "function" then
            local holder_ent = item.ownerInventory and item.ownerInventory.owner
            return item:canUseItem(holder_ent, ...) -- return callback value
        else
            return item.canUseItem -- it's probably a boolean
        end
    end

    return true
    -- no `canUseItem` component; assume that it can be used.
end



usable_items:on_added(function(ent)
    assert(type("useItem") == "function", "ent.useItem needs to be a function")
    ent.use = useMethod
    ent.canUse = canUseMethod
end)





server.filter("useItem", function(sender, item, holder_ent)
    if not (exists(item) and exists(holder_ent)) then
        return
    end
    if sender ~= holder_ent.controller then
        return
    end
    if item.ownerInventory ~= holder_ent.inventory then
        return
    end
end)



server.on("useItem", function(username, item, holder_ent, ...)
    if not item:canUse(...) then
        return
    end
    
    item:useItem(holder_ent, ...)
end)


