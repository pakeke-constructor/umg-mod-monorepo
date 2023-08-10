

-- is velocity disabled for this entity?
umg.defineQuestion("xy:isVelocityDisabled", reducers.OR)

-- Is vertical velocity disabled for this entity?
umg.defineQuestion("xy:isVerticalVelocityDisabled", reducers.OR)

-- Is friction disabled? 
umg.defineQuestion("xy:isFrictionDisabled", reducers.OR)



-- Gets the flat speed of an entity
umg.defineQuestion("xy:getSpeed", reducers.ADD)

-- Gets the speed multiplier of an entity
umg.defineQuestion("xy:getSpeedMultiplier", reducers.MULTIPLY)

