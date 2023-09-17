

local items = {}


items.Inventory = require("shared.inventory")
items.SlotHandle = require("shared.slot_handle")


if server then
    local groundAPI = require("server.ground_items")
    items.drop = groundAPI.drop
end


umg.expose("items", items)
