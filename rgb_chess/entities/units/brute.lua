
local abstractMelee = require("shared.abstract.abstract_melee")


return umg.extend(abstractMelee, {
    image = "huhu1",
    bobbing = {},

    defaultHealth = 100,
    defaultAttackSpeed = 1,
    defaultAttackDamage = 8,

    abilities = {
        {
            trigger = "reroll",
            target = "allies",
            action = "buff4",
        }
    },

    cardInfo = {
        type = constants.CARD_TYPES.UNIT,
        cost = 3,
        name = "Brute x 1",
        description = "on ally death,\nprint hi in console",
        unitInfo = {
            symbol = "dice",
            squadronSize = 1
        }
    },

    init = base.initializers.initVxVy
})

