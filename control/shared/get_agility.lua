
require("control_questions")


local DEFAULT_AGILITY = 100


local function getAgility(ent)
    local agility = ent.agility or DEFAULT_AGILITY

    local agility_add = umg.ask("control:getAgilityModifier", reducers.ADD, ent) or 0
    local agility_multiplier = umg.ask("control:getAgilityMultiplier", reducers.MULTIPLY, ent) or 1

    return (agility + agility_add) * agility_multiplier
end


return getAgility
