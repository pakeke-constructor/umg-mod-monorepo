
local abstractMelee = require("shared.abstract.abstract_melee")


return umg.extend(abstractMelee, {
    image = "huhu1",
    bobbing = {},

    defaultHealth = 100,
    defaultAttackSpeed = 1,
    defaultPower = 8,

    defaultAbilities = {
        {
            trigger = "allyBuff",
            filters = {}, -- {"hasLessDamage"},
            target = "matching",
            action = "buffHealth2",
        }
    },

    cardInfo = {
        type = constants.CARD_TYPES.UNIT,
        cost = 3,
        name = "Brute x 1",
        description = "on ally death,\nprint hi in console",
        difficultyLevel = 0,

        unitInfo = {
            symbol = "dice",
            squadronSize = 1
        }
    },

    init = base.initializers.initVxVy
})

