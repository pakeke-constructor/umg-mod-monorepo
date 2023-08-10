


-- gets the flat regeneration of an entity
umg.defineQuestion("mortality:getRegeneration", reducers.ADD)


-- gets the regeneration multiplier of an entity
umg.defineQuestion("mortality:getRegenerationMultiplier", reducers.ADD)


-- gets the damage reduction (armor) of an entity.
-- 0.5 = takes 50% less damage
-- 3 = the entity takes three times MORE damage!
umg.defineQuestion("mortality:getDamageTakenModifier", reducers.MULTIPLY)


