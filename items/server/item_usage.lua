


local usable_items = group("itemName", "useItem")


local function useMethod(item, ...)
    -- item.ownerInventory is set by the inventory.
    -- If this item is not in any inventory, then it's nil
    local holder_ent = item.ownerInventory and item.ownerInventory.owner
    if item:canUse(...) then
        server.broadcast("useItem", item, holder_ent, ...)
        item:useItem(holder_ent, ...)
    elseif item.useItemDeny then
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
    if (type(ent.useItem) ~= "function") then 
        error("ent.useItem needs to be a function. Instead, it was "..type(ent.useItem))
    end
    ent.use = useMethod
    ent.canUse = canUseMethod
end)





server.filter("useItem", function(sender, item, holder_ent)
    if not (exists(item) and exists(holder_ent)) then
        return false
    end
    if sender ~= holder_ent.controller then
        return false
    end
    if item.ownerInventory ~= holder_ent.inventory then
        return false
    end
    return true
end)



server.on("useItem", function(username, item, holder_ent, ...)
    if item:canUse(...) then 
        item:useItem(holder_ent, ...)
        server.broadcast("useItem", username, item, holder_ent, ...)
    end
end)


