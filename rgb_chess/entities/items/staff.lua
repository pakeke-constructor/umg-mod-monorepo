

return {
    image = "anvil1",

    maxStackSize = 1,

    itemType = constants.ITEM_TYPES.USABLE,

    itemHoldType = "recoil",

    useItem = function(self, holderEnt, targetEnt)
        if server then
            -- todo: holderEnt.sorcery should be GUARANTEED.
            rgbAPI.damage(holderEnt, targetEnt, holderEnt.sorcery or 0)
        end
    end,

    itemInfo = {
        rarity = 1,
        minimumTurn = 1,
    },

    itemName = "target"
}
