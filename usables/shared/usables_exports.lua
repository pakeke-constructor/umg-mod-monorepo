
local common = require("shared.common")
local holding = require("shared.holding")

local usables = {}


usables.getHoldItem = common.getHoldItem
usables.getHoldDistance = common.getHoldDistance


usables.equipItem = holding.equipItem
usables.unequipItem = holding.unequipItem
usables.updateHoldItemDirectly = holding.updateHoldItemDirectly



umg.expose("usables", usables)
