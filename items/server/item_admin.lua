

local updateStackSize = require("server.update_stacksize")


local itemGroup = umg.group("itemName")


itemGroup:onAdded(function(item_ent)
    if not item_ent:isShared("maxStackSize") then
        error("item entity doesn't have a shared .maxStackSize component: " .. item_ent:type())
    end
    if not item_ent.stackSize then
        item_ent.stackSize = 1
    end

    -- This is for delta compression.
    item_ent.last_seen_stackSize = item_ent.stackSize
end)


umg.on("@tick", function()
    for _, item_ent in ipairs(itemGroup) do
        updateStackSize(item_ent)
    end
end)


