
local common = require("shared.common")




local holding = {}


local holdingItemGroup = umg.group("holdItem", "x", "y")


local getHoldDistance = common.getHoldDistance
local getHoldItem = common.getHoldItem



local function defaultHandler(itemEnt, holderEnt)
    local x, y = holderEnt.x, holderEnt.y
    itemEnt.x, itemEnt.y = x, y - getHoldDistance(itemEnt, holderEnt)
end



local entity2Tc = typecheck.assert("entity", "entity")


function holding.updateHoldItemDirectly(itemEnt, holderEnt)
    entity2Tc(itemEnt, holderEnt)

    local handlerFunc = umg.ask("usables:getHoldItemHandler", itemEnt, holderEnt)
    handlerFunc = handlerFunc or defaultHandler
    handlerFunc(itemEnt, holderEnt)
    -- todo: we can ask more/better questions here

    umg.call("usables:updateHoldItem", itemEnt, holderEnt)

    itemEnt.dimension = dimensions.getDimension(holderEnt.dimension)
end




local function updateHolderEnt(ent)
    local holdItem = getHoldItem(ent)
    if holdItem then
        holding.updateHoldItemDirectly(holdItem, ent)
    end
end






--[[
==============================
   SERVER
==============================
]]

if server then

local function remPosComponents(item)
    -- remove item position on invalidation:
    item:removeComponent("x")
    item:removeComponent("y")
    item:removeComponent("dimension")
end


local entityItemTc = typecheck.assert("entity", "voidentity")
function holding.equipItem(holderEnt, itemEnt)
    entityItemTc(holderEnt, itemEnt)

    holderEnt.holdItem = itemEnt
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
    remPosComponents(itemEnt)
    umg.call("usables:unequipItem", itemEnt, holderEnt)
    holderEnt:removeComponent("holdItem")
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
