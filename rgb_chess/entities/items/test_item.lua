
local abilities = require("shared.abilities.abilities")


return {
    image = "target",

    maxStackSize = 1,

    abilities = {abilities.test},

    itemInfo = {
        rarity = 1,
        minimumTurn = 1,
    },

    itemName = "test",

    init = base.initializers.initXY
}
