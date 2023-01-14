

local function loadServer(items)
    local itemHolding = require("server.item_holding")
    items.setHoldItem = itemHolding.setHoldItem
end


local function loadShared(items)
    local Inventory = require("inventory")
    items.Inventory = Inventory
    
    local itemUsage
    if server then
        itemUsage = require("server.item_usage")
    else
        itemUsage = require("client.item_usage")
    end
    items.canUseHoldItem = itemUsage.canUseHoldItem
    items.useHoldItem = itemUsage.useHoldItem
end



base.defineExports({
    name = "items",
    loadServer = loadServer,
    loadShared = loadShared
})


