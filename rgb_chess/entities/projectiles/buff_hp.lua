
--[[

This entity is spawned when we want to buff an entity's health.


]]

local constants = require("shared.constants")

return extend("abstract_buff", {
    color = {1,0.1,0.2},
    buffType = constants.BUFF_TYPES.HEALTH
})

