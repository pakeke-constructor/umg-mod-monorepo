
local abstractUnit = require("shared.abstract.abstract_unit")

local SORCERER_RANGE = 1000


--[[
    abstract sorcerer entity

    entities that extend this will inherit these components:
]]
return umg.extend(abstractUnit, {
    unitType = constants.UNIT_TYPES.SORCERER,
    defaultAttackSpeed = 2,

    attackBehaviour = {
        range = SORCERER_RANGE,
        type = "item",
    };

    moveBehaviour = {
        type = "follow";
        activateDistance = SORCERER_RANGE,
    };
})

