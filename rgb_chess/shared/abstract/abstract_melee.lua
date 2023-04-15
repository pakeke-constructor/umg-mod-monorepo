
local MELEE_RANGE = 30

local abstractUnit = require("shared.abstract.abstract_unit")


--[[
    abstract melee entity

    entities that extend this will inherit these components:
]]
return umg.extend(abstractUnit, {
    unitType = constants.UNIT_TYPES.MELEE,

    attackBehaviour = {
        type = "melee",
        range = MELEE_RANGE
    };

    moveBehaviour = {
        type = "follow";
        activateDistance = 1000,
    };
})

