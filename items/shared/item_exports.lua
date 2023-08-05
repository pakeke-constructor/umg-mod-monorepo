

local function loadShared(items)
    local Inventory = require("inventory")
    items.Inventory = Inventory
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


