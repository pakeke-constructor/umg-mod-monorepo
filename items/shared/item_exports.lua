

local items = {}


items.Inventory = require("shared.inventory")
items.SlotHandle = require("shared.slot_handle")


if server then
    local groundItemsHandler = require("server.ground_items_handler")
    items.setDropHandler = groundItemsHandler.setDropHandler
    items.drop = groundItemsHandler.drop
end


umg.expose("items", items)
