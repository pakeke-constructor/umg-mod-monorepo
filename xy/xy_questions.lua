

-- is velocity disabled for this entity?
umg.defineQuestion("xy:isVelocityDisabled", reducers.OR)

-- Is vertical velocity disabled for this entity?
umg.defineQuestion("xy:disableVerticalVelocity", reducers.OR)



-- Gets the flat speed of an entity
umg.defineQuestion("xy:getSpeed", reducers.ADD)

-- Gets the speed multiplier of an entity
umg.defineQuestion("xy:getSpeedMultiplier", reducers.MULTIPLY)

