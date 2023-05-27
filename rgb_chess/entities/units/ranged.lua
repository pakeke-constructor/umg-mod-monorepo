
local abstractRanged = require("shared.abstract.abstract_ranged")
local constants = require("shared.constants")


return umg.extend(abstractRanged, {
    image = "red_player_up_1",
    bobbing = {},

    defaultAbilities = {},

    projectileType = constants.PROJECTILE_TYPES.DAMAGE,

    defaultHealth = 100,
    defaultAttackSpeed = 1,
    defaultPower = 8,

    init = base.initializers.initVxVy
})

