
local common = require("shared.common")




local holdItems = {}


local holdingItemGroup = umg.group("holdItem", "x", "y")


local getHoldDistance = common.getHoldDistance
local getHoldItem = common.getHoldItem



local function defaultHandler(itemEnt, holderEnt)
    local x, y = holderEnt.x, holderEnt.y
    itemEnt.x, itemEnt.y = x, y - getHoldDistance(itemEnt, holderEnt)
end



local entity2Tc = typecheck.assert("entity", "entity")


function holdItems.updateHoldItemDirectly(itemEnt, holderEnt)
    entity2Tc(itemEnt, holderEnt)

    -- todo: we can ask more/better questions here
    local handlerFunc = umg.ask("usables:getHoldItemHandler", itemEnt, holderEnt)
    handlerFunc = handlerFunc or defaultHandler

    handlerFunc(itemEnt, holderEnt)

    itemEnt.dimension = holderEnt.dimension
end




local function updateHolderEnt(ent)
    local holdItem = getHoldItem(ent)
    if holdItem then
        holdItems.updateHoldItemDirectly(ent, holdItem)
    end
end



local function equipItem(holderEnt, slotX, slotY)
    -- holds the item at slot (slotX, slotY) in ent's inventory
    local holdItem = holderEnt.holdItem or {}
    holdItem.slotX = slotX
    holdItem.slotY = slotY

    local item = holderEnt.inventory:get(slotX, slotY)
    if item then
        umg.call("usables:equipItem", item, holderEnt)
    end
end





local EV_NAME = "usables.equipItem"
local sf = sync.filters


if client then

function holdItems.equipItem(holderEnt, slotX, slotY)
    if sync.isClientControlling(holderEnt) then
        client.send(EV_NAME, holderEnt, slotX, slotY)
    end
end

client.on(EV_NAME, function(holderEnt, slotX, slotY)
    equipItem(holderEnt, slotX, slotY)
end)



elseif server then

function holdItems.equipItem(holderEnt, slotX, slotY)
    server.broadcast(EV_NAME, holderEnt, slotX, slotY)
end

server.on(EV_NAME, {
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



end



local function removePositionComponents(itemEnt)
    if itemEnt:hasComponent("x") then
        itemEnt:removeComponent("x")
    end

    if itemEnt:hasComponent("y") then
        itemEnt:removeComponent("y")
    end

    if itemEnt:hasComponent("dimension") then
        itemEnt:removeComponent("dimension")
    end
end


local entityTc = typecheck.assert("entity")

function holdItems.unequipItem(holderEnt, itemEnt)
    entityTc(holderEnt)
    itemEnt = itemEnt or getHoldItem(holderEnt)
    if not itemEnt then
        return
    end

    if server then
        removePositionComponents(itemEnt)
    end

    umg.call("usables:unequipItem", itemEnt, holderEnt)
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

-- We only need to update per tick, as this is what client sees
umg.on("@tick", function()
    for _, ent in ipairs(holdingItemGroup) do
        updateHolderEnt(ent)
    end
end)

end

