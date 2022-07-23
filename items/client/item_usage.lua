

local usable_items = group("itemName", "useItem")

local itemRendering = require("client.item_rendering")


local function useMethod(item, ...)
    -- item.ownerInventory is set by the inventory.
    -- If this item is not in any inventory, then it's nil
    local holder_ent = item.ownerInventory and item.ownerInventory.owner
    if item:canUse(...) then
        client.send("useItem", item, holder_ent, ...)
        item:useItem(holder_ent, ...)
        itemRendering.onUseItem(item, holder_ent, ...)
    elseif item.useItemDeny then
        item:useItemDeny(holder_ent, ...)
    end
end


local function adminCanUse(item_ent, holder_ent)
    return holder_ent and holder_ent.controller == username and 
            item_ent.ownerInventory == holder_ent.inventory
end


local function canUseMethod(item, ...)
    local holder_ent = item.ownerInventory and item.ownerInventory.owner
    if not adminCanUse(item, holder_ent) then
        -- if the client does not own the entity, then they obviously aren't
        -- allowed to use it!
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
    -- no `canUseItem` component; assume that it can be used.
end



usable_items:onAdded(function(ent)
    if (type(ent.useItem) ~= "function") then 
        error("ent.useItem needs to be a function. Instead, it was "..type(ent.useItem))
    end
    ent.use = useMethod
    ent.canUse = canUseMethod
end)




client.on("useItem", function(sender, item, holder_ent, ...)
    if sender == username then
        return -- ignore; we have already called `useItem`, 
        -- since we are the ones who sent the event!
    end

    item:useItem(holder_ent, ...)
end)

