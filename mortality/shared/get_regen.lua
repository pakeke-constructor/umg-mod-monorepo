
require("mortality_questions")



local function getRegeneration(ent)
    --[[
        gets the health regeneration for an entity
    ]]
    local regen = (ent.regen or 0)
    regen = regen + (umg.ask("mortality:getRegeneration", reducers.ADD, ent) or 0)
    regen = regen * (umg.ask("mortality:getRegenerationMultiplier", reducers.ADD, ent) or 1)
    return regen
end


return getRegeneration
