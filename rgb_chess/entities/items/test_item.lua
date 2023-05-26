


return {
    image = "target",

    itemName = "test",

    maxStackSize = 1,

    defaultAbilities = {
        {
            trigger = "allyBuff",
            filters = {}, -- {"hasLessDamage"},
            target = "matching",
            action = "buffHealth2",
        }
    },

    itemType = constants.ITEM_TYPES.PASSIVE,

    itemInfo = {
        rarity = 1,
        minimumTurn = 1,
    }
}

