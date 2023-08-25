
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

    itemEnt.dimension = holderEnt.dimension
end




local function updateHolderEnt(ent)
    local holdItem = getHoldItem(ent)
    if holdItem then
        holding.updateHoldItemDirectly(holdItem, ent)
    end
end





local function setHoldValues(holderEnt, slotX, slotY)
    -- holds the item at slot (slotX, slotY) in ent's inventory
    local holdItem = holderEnt.holdItem or {}
    holdItem.slotX = slotX
    holdItem.slotY = slotY
end




local EQUIP_EV = "usables.equipItem"
local UNEQUIP_EV = "usables.unequipItem"

local sf = sync.filters



if client then
--[[
==============================
   SERVER
==============================
]]
function holding.equipItem(holderEnt, slotX, slotY)
    if sync.isClientControlling(holderEnt) then
        client.send(EQUIP_EV, holderEnt, slotX, slotY)
    end
end

function holding.unequipItem(holderEnt, slotX, slotY)
    if sync.isClientControlling(holderEnt) then
        client.send(UNEQUIP_EV, holderEnt, slotX, slotY)
    end
end










--[[
==============================
   SERVER
==============================
]]

elseif server then

local function equipItem(holderEnt, slotX, slotY)
    setHoldValues(holderEnt, slotX, slotY)
    local inv = holderEnt.inventory
    local item = inv:get(slotX, slotY)
    if item then
        holderEnt.holdItem = inv:retrieveItemHandle(slotX, slotY)
        umg.call("usables:equipItem", item, holderEnt)
    end
end

local function removeComponents(item)
    -- remove item position on invalidation:
    if item:hasComponent("x") then
        item:removeComponent("x")
    end
    if item:hasComponent("y") then
        item:removeComponent("y")
    end
    if item:hasComponent("dimension") then
        item:removeComponent("dimension")
    end
end

local function unequipItem(holderEnt, holdItem)
    holdItem = holdItem or getHoldItem(holderEnt)
    if not holdItem then
        return
    end

    removeComponents(holdItem)
    local inv = holderEnt.inventory
    if inv and inv:getExistingItemHandle(holdItem) then
        -- invalidate 
        local itemHandle = inv:getExistingItemHandle(holdItem)
        itemHandle:invalidate()
    end
    umg.call("usables:unequipItem", holdItem, holderEnt)
    holderEnt:removeComponent("holdItem")
end

function holding.equipItem(holderEnt, slotX, slotY)
    local prevItem = getHoldItem(holderEnt)
    if prevItem then
        -- unequip previous item
        unequipItem(holderEnt, prevItem)
    end
    -- equip new item:
    server.broadcast(EQUIP_EV, holderEnt, slotX, slotY)
    setHoldValues(holderEnt, slotX, slotY)
    equipItem(holderEnt, slotX, slotY)
end

umg.on("items:itemRemoved", function(holderEnt, itemEnt)
    -- if an item is removed from an inventory whilst holding,
    -- unequip that item.
    local holdItem = getHoldItem(holderEnt)
    if holdItem == itemEnt then
        unequipItem(holderEnt)
    end
end)


server.on(EQUIP_EV, {
    arguments = {sf.controlEntity, sf.number, sf.number},
    handler = function(sender, ent, slotX, slotY)
        local inv = ent.inventory
        if not inv then return end
        slotX = math.floor(slotX)
        slotY = math.floor(slotY)
        
        if inv:slotExists(slotX,slotY) then
            equipItem(ent, slotX, slotY)
        end
    end
})

server.on(UNEQUIP_EV, {
    arguments = {sf.controlEntity},
    handler = function(sender, ent)
        local inv = ent.inventory
        if not inv then return end
        unequipItem(ent)
    end
})

local entityTc = typecheck.assert("entity")

function holding.unequipItem(holderEnt, itemEnt)
    -- programmatically unequip items:
    entityTc(holderEnt)
    unequipItem(holderEnt, itemEnt)
end

umg.on("items:itemHandleInvalidated", function(itemEnt, itemHandle, invEnt)
    if itemHandle:getFlag("holdItem") then
        holding.unequipItem(invEnt, itemEnt)
    end
end)

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
    if not items.ItemHandle.isInstance(ent.holdItem) then
        -- if it's not an ItemHandle, check for existance,
        -- and remove if not-exist.
        if not umg.exists(ent.holdItem) then
            ent:removeComponent("holdItem")
        end
        return
    end

    -- if is an itemHandle, and is invalid:
    if not ent.holdItem:isValid() then
        local itemEnt = ent.holdItem:rawget()
        if umg.exists(itemEnt) then
            holding.unequipItem(ent, itemEnt)
        end
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
