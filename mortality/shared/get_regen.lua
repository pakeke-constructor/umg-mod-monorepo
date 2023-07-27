

local function getRegeneration(ent)
    --[[
        gets the health regeneration for an entity
    ]]
    local regen = (ent.regen or 0)
    regen = regen + (umg.ask("getRegeneration", reducers.ADD, ent) or 0)
    regen = regen * (umg.ask("getRegenerationMultiplier", reducers.ADD, ent) or 1)
    return regen
end


return getRegeneration
