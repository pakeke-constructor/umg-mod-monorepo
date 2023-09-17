
-- item usage
-- returns whether an item is blocked from being able to be used
umg.defineQuestion("usables:itemUsageBlocked", reducers.OR)



--[[
OK: This one is a lil bit confusing: 

Gets hold item position handler.
answerers to this question should return a function.
The function should mutate the position, rotation,
and scale values of the holdItem, depending on how it's being held.

The reason we are using a question for this, (as opposed to event,)
is because we want to guarantee that only ONE function is handling the
setting of positions for items, as opposed to a bunch of systems overwriting
each other.
]]
umg.defineQuestion("usables:getHoldItemHandler", reducers.PRIORITY)

