
--[[

This entity is spawned when we want to buff an entity's damage.


]]

local constants = require("shared.constants")

return extend("abstract_buff", {
    color = {0.5,0.9,0.3},
    buffType = constants.BUFF_TYPES.ATTACK_DAMAGE
})


