
local abstractSorcerer = require("shared.abstract.abstract_sorcerer")
local constants = require("shared.constants")


return umg.extend(abstractSorcerer, {
    image = "red_player_up_1",
    bobbing = {},

    defaultHealth = 30,
    defaultSorcery = 5,

    defaultAbilities = {
        {
            trigger = "reroll",
            filters = {}, -- {"hasLessDamage"},
            target = "matching",
            action = "buffAttackDamage2",
        }
    },

    cardInfo = {
        type = constants.CARD_TYPES.UNIT,
        cost = 3,
        name = "Sorc x 1",
        description = "Basic sorcerer",
        unitInfo = {
            symbol = "wizard unit",
            squadronSize = 1
        }
    },

    init = base.initializers.initVxVy
})

