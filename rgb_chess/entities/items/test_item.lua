
local abilities = require("shared.abilities.abilities")


return {
    image = "target",

    maxStackSize = 1,

    abilities = {abilities.test},

    itemType = constants.ITEM_TYPES.PASSIVE,

    itemInfo = {
        rarity = 1,
        minimumTurn = 1,
    },

    itemName = "test"
}
