

local itemUsage
if server then
    itemUsage = require("server.item_usage")
else
    itemUsage = require("client.item_usage")
end
items.canUseHoldItem = itemUsage.canUseHoldItem
items.useHoldItem = itemUsage.useHoldItem

