

-- is velocity disabled for this entity?
umg.defineQuestion("isVelocityDisabled", reducers.OR)

-- Is vertical velocity disabled for this entity?
umg.defineQuestion("disableVerticalVelocity", reducers.OR)



-- Gets the flat speed of an entity
umg.defineQuestion("getSpeed", reducers.ADD)

-- Gets the speed multiplier of an entity
umg.defineQuestion("getSpeedMultiplier", reducers.MULTIPLY)

