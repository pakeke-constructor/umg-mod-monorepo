
local abstractUnit = require("shared.abstract.abstract_unit")


local RANGE = 200

--[[
    abstract ranged entity

    entities that extend this will inherit these components:
]]
return umg.extend(abstractUnit, {
    unitType = constants.UNIT_TYPES.RANGED,

    attackBehaviour = {
        type = "ranged",
        range = RANGE,
    };

    moveBehaviour = {
        type = "follow";
        activateDistance = 1000,
    };
})

