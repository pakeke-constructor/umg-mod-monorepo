
--[[

This entity is spawned when we want to buff an entity's attack speed.


]]

local constants = require("shared.constants")


return extend("abstract_buff", {
    color = {0.7,0.7,0.2},
    buffType = constants.BUFF_TYPES.ATTACK_SPEED
})

