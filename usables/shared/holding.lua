

local holdItems = {}


local holdingItemGroup = umg.group("holdItem", "x", "y")




local function updateHoldItem(itemEnt, holderEnt)
    if not itemEnt then
        return
    end

    local x, y = holderEnt.x, holderEnt.y

    -- todo: we can ask more/better questions here
    x, y = umg.ask("usables:getItemHoldPosition", itemEnt, holderEnt)

    itemEnt.dimension = holderEnt.dimension
    itemEnt.x, itemEnt.y = x, y
end




local function updateHolderEnt(ent)
    if not ent.holdItem then
        return
    end
    updateHoldItem(ent, ent.holdItem)
end



function holdItems.equipItem(ent, invX, invY)
    -- holds the item at slot (invX, invY) in ent's inventory
end


function holdItems.unequipItem(ent)
    
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

