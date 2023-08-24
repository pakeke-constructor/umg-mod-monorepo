

local function loadShared(items)
    items.Inventory = require("shared.inventory")
    items.ItemHandle = require("shared.item_handle")
    
    local itemUsage
    if server then
        itemUsage = require("server.item_usage")
    else
        itemUsage = require("client.item_usage")
    end
    items.canUseHoldItem = itemUsage.canUseHoldItem
    items.useHoldItem = itemUsage.useHoldItem
end


local function loadServer(items)
    local groundItemsHandler = require("server.ground_items_handler")
    items.setDropHandler = groundItemsHandler.setDropHandler
    items.drop = groundItemsHandler.drop
end


base.defineExports({
    name = "items",
    loadShared = loadShared,
    loadServer = loadServer
})


