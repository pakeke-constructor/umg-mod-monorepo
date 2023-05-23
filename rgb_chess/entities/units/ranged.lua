
local abstractRanged = require("shared.abstract.abstract_ranged")
local constants = require("shared.constants")


return umg.extend(abstractRanged, {
    image = "red_player_up_1",
    bobbing = {},

    projectileType = constants.PROJECTILE_TYPES.DAMAGE,

    attackSpeed = 0.1,
    attackDamage = 0.5,

    maxHealth = 100,

    init = base.initializers.initVxVy
})

