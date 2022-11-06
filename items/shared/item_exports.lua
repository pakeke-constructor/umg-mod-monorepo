

local function loadServer(items)
    local itemHolding = require("server.item_holding")
    items.setHoldItem = itemHolding.setHoldItem
end


local function loadShared(items)
    local Inventory = require("inventory")
    items.Inventory = Inventory
end



base.defineExports({
    name = "items",
    loadServer = loadServer,
    loadShared = loadShared
})


