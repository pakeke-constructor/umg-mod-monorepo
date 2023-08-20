
--[[


Handles usage of items.


]]

local usables = {}

require("usables_events")
require("usables_questions")




local DEFAULT_ITEM_COOLDOWN = 0.2


local function getHoldItem(ent)
    local inv = ent.inventory
    if inv then
        local item = inv:getHoldItem()
        return umg.exists(item) and item
    end
end



local function isUseItem(item)

end



function usables.canUseHoldItem(holder_ent, item, ...)
    if (not umg.exists(holder_ent)) or (not umg.exists(item)) then
        return false
    end

    -- TODO: wot?
    if not item.useItem then
        return false
    end

    local time = state.getGameTime()
    local time_since_use = time - (item.itemLastUseTime or 0)
    local cooldown = (item.itemCooldown or DEFAULT_ITEM_COOLDOWN)
    if math.abs(time_since_use) < cooldown then
        return false
    end

    local usageBlocked = umg.ask("usables:itemUsageBlocked", holder_ent, item, ...)
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




local function useItemDeny(item, holder_ent, ...)
    if type(item.useItemDeny) == "function" then
        item:useItemDeny(holder_ent, ...)
    end
    umg.call("usables:useItemDeny", holder_ent, item, ...)
end









if server then

function usables.useHoldItem(holder_ent, ...)
    local item = getHoldItem(holder_ent)
    if item then
        if usables.canUseHoldItem(holder_ent) then
            usables.useItemDirectly(holder_ent, item, ...)
        else
            useItemDeny(item, holder_ent, ...)
        end
    end
end

local asserterDirect = typecheck.assert("entity?", "entity")

function usables.useItemDirectly(holder_ent, item, ...)
    asserterDirect(holder_ent, item)
    -- holder_ent could be nil here
    if type(item.useItem) == "function" then
        item:useItem(holder_ent or false, ...)
    end
    umg.call("usables:useItem", holder_ent, item, ...)
    server.broadcast("useItem", holder_ent, item, ...)
    item.itemLastUseTime = state.getGameTime()
end

local sf = sync.filters
server.on("usables:useItem", {
    arguments = {sf.entity},
    handler = function(sender, holder_ent, ...)
        if not umg.exists(holder_ent) then return end
        if not getHoldItem(holder_ent) then return end
        if holder_ent.controller ~= sender then return end

        usables.useHoldItem(holder_ent, ...)
    end
})

end











if client then

local function canUse(holder_ent)
    return sync.isClientControlling(holder_ent)
        and usables.canUseHoldItem(holder_ent)
end

local asserter = typecheck.assert("entity")

function usables.useHoldItem(holder_ent, ...)
    asserter(holder_ent)
    local item = holder_ent.inventory and holder_ent.inventory:getHoldItem()
    if canUse(holder_ent) then
        asserter(holder_ent)
        client.send("usables:useItem", holder_ent, ...)
        umg.call("usables:useItem", holder_ent, item, ...)
        if type(item.useItem) == "function" then
            item:useItem(holder_ent or false, ...)
        end
        item.itemLastUseTime = state.getGameTime()
    elseif item then
        useItemDeny(item, holder_ent, ...)
    end
end

umg.on("usables:useItem", function(holder_ent, item, ...)
    if holder_ent and sync.isClientControlling(holder_ent) then
        return -- ignore; we have already called `useItem`, 
        -- since we are the ones who sent the event!
    end
    item:useItem(holder_ent, ...)
    item.itemLastUseTime = state.getGameTime()
end)

end



return usables

