

local holdingItemGroup = umg.group("holdItems", "x", "y")




local function updateHoldItem(itemEnt, holderEnt, i, len)
    -- todo: we can ask better questions here
    local x, y = holderEnt.x, holderEnt.y

    x, y = umg.ask("usables:getItemHoldPosition", itemEnt, holderEnt, i, len)

    itemEnt.dimension = holderEnt.dimension
    itemEnt.x, itemEnt.y = x, y
end




local function updateHolderEnt(ent)
    if not ent.holdItems then
        return
    end

    -- update all held items:
    local len = #ent.holdItems
    for i, itemEnt in ipairs(ent.holdItems) do
        updateHoldItem(ent, itemEnt, i, len)
    end
end




if client then

umg.on("state:gameUpdate", function()
    for _, ent in ipairs(holdingItemGroup) do
        updateHolderEnt(ent)
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

