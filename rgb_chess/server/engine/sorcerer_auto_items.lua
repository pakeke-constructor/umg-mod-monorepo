
--[[

Sorcerer entities automatically hold items.

]]


local sorcererGroup = umg.group("unitType", "inventory")


local function isUsableItem(item)
    return item.itemType == constants.ITEM_TYPES.USABLE
end



local function findBestItem(ent)
    --[[
        finds the top-left item as first choice.
    ]]
    local inv = ent.inventory
    for x=1, inv.width do
        for y=1, inv.height do
            local item = inv:get(x,y)
            if umg.exists(item) and isUsableItem(item) then
                return item
            end
        end
    end
end




local function holdStaffAutomatically(ent)
    local item = findBestItem(ent)
    local inv = ent.inventory
    if inv and inv:getHoldItem() ~= item then
        inv:hold(item)
    end
end



umg.on("@tick", function()
    for _, ent in ipairs(sorcererGroup)do
        if ent.unitType == constants.UNIT_TYPES.SORCERER then
            holdStaffAutomatically(ent)
        end
    end
end)

