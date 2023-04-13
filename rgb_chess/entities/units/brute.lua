

return umg.extend("abstract_melee", {
    image = "huhu1",
    bobbing = {},

    defaultHealth = 100,
    defaultAttackSpeed = 1,
    defaultAttackDamage = 8,

    attackSpeed = 1,
    attackDamage = 8,

    maxHealth = 100,

    abilities = {
        {
            type = "onAllyDeath", 
            filter = function(ent, allyEnt)
                return ent == allyEnt
            end,
            apply = function()
                print("hi")
            end
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

