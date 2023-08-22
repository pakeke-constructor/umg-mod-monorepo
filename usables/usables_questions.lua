
-- item usage
umg.defineQuestion("usables:itemUsageBlocked", reducers.OR)



--[[
OK: This one is a lil bit confusing: 

Gets hold item position handler.
answerers to this question should return a function.

The function should mutate the position, rotation,
and scale values of the holdItem, depending on how it's being held.
]]
umg.defineQuestion("usables:getHoldItemHandler", reducers.PRIORITY)

