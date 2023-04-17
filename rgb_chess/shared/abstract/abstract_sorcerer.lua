
local abstractUnit = require("shared.abstract.abstract_unit")



--[[
    abstract sorcerer entity

    entities that extend this will inherit these components:
]]
return umg.extend(abstractUnit, {
    unitType = constants.UNIT_TYPES.SORCERER,

    attackBehaviour = {
        type = "item",
    };

    moveBehaviour = {
        type = "follow";
        activateDistance = 1000,
    };
})

