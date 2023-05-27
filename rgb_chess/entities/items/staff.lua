

return {
    image = "wooden_staff",

    maxStackSize = 1,

    itemType = constants.ITEM_TYPES.USABLE,

    itemHoldType = "recoil",
    itemHoldRotation = -3*(math.pi/4),

    useItem = function(self, holderEnt, targetEnt)
        if server then
            rgbAPI.damage(holderEnt, targetEnt, holderEnt.power or 0)
        end
    end,

    itemInfo = {
        rarity = 1,
        minimumTurn = 1,
    },

    itemName = "target"
}
