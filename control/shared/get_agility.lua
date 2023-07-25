

local DEFAULT_AGILITY = 10


local function getAgility(ent)
    local agility = ent.agility or DEFAULT_AGILITY

    local agility_add = umg.ask("getAgilityModifier", reducers.ADD, ent) or 0
    local agility_multiplier = umg.ask("getAgilityMultiplier", reducers.MULTIPLY, ent) or 1

    return (agility + agility_add) * agility_multiplier
end



return getAgility
