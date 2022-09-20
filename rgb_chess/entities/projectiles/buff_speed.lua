
--[[

This entity is spawned when we want to buff an entity's speed.


]]

local constants = require("shared.constants")


return extend("abstract_buff", {
    color = {0.2,0.2,1},
    buffType = constants.BUFF_TYPES.SPEED
})

