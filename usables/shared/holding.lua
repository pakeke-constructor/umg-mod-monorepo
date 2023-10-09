
local common = require("shared.common")




local holding = {}


local holdingItemGroup = umg.group("holdItem", "x", "y")


local getHoldDistance = common.getHoldDistance
local getHoldItem = common.getHoldItem



local function defaultHandler(itemEnt, holderEnt)
    local x, y = holderEnt.x, holderEnt.y
    itemEnt.x, itemEnt.y = x, y - getHoldDistance(itemEnt, holderEnt)
end




local function updateHolderEnt(holderEnt)
    local itemEnt = getHoldItem(holderEnt)
    if not itemEnt then
        return -- no hold item
    end

    if server and (not itemEnt.holdable) then
        -- unequip the item! its no longer holdable.
        holding.unequipItem(holderEnt, itemEnt)
        return
    end

    local handlerFunc = umg.ask("usables:getHoldItemHandler", itemEnt, holderEnt)
    handlerFunc = handlerFunc or defaultHandler
    handlerFunc(itemEnt, holderEnt)
    -- todo: we can ask more/better questions here

    umg.call("usables:updateHoldItem", itemEnt, holderEnt)

    itemEnt.dimension = dimensions.getDimension(holderEnt.dimension)
end






--[[
==============================
   SERVER
==============================
]]

if server then

local function remItemComponents(item)
    -- remove item position on invalidation:
    item:removeComponent("x")
    item:removeComponent("y")
    item:removeComponent("dimension")

    item:removeComponent("controllable")
    item:removeComponent("controller")
end


local EMPTY = {}

local entityItemTc = typecheck.assert("entity", "voidentity")
function holding.equipItem(holderEnt, itemEnt)
    entityItemTc(holderEnt, itemEnt)
    if not itemEnt.holdable then
        error("item is not holdable: (has no .holdable component)", itemEnt)
    end

    holderEnt.holdItem = itemEnt

    if holderEnt.controller then
        itemEnt.controllable = itemEnt.controllable or EMPTY
        -- We must set `controllable` comp here. See sync/control for why
        itemEnt.controller = holderEnt.controller
        sync.syncComponent(itemEnt, "controller")
    end

    umg.call("usables:equipItem", itemEnt, holderEnt)
end

function holding.unequipItem(holderEnt, itemEnt)
    -- programmatically unequip a held item:
    entityItemTc(holderEnt, itemEnt)

    -- if no item is specified, automatically try get the holdItem comp:
    itemEnt = itemEnt or getHoldItem(holderEnt)
    if not itemEnt then
        return
    end
    remItemComponents(itemEnt)
    holderEnt:removeComponent("holdItem")
    umg.call("usables:unequipItem", itemEnt, holderEnt)
end

end







if client then

umg.on("state:gameUpdate", function()
    for _, ent in ipairs(holdingItemGroup) do
        if sync.isClientControlling(ent) then
            updateHolderEnt(ent)
        end
    end
end)

elseif server then

local function removeIfInvalid(ent)
    local holdItem = ent.holdItem
    -- remove if dead entity.
    -- TODO: Do we need this code...?
    -- I guess its better safe than sorry... :-)
    if not umg.exists(holdItem) then
        ent:removeComponent("holdItem")
    end
end

-- We only need to update per tick, as this is what client sees
umg.on("@tick", function()
    for _, ent in ipairs(holdingItemGroup) do
        removeIfInvalid(ent)
        updateHolderEnt(ent)
    end
end)

end





return holding
