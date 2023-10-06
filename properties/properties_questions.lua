

umg.defineQuestion("properties:getPropertyMultiplier", reducers.MULTIPLY)

umg.defineQuestion("properties:getPropertyModifier", reducers.ADD)


local max, min = math.max, math.min
local function clampCombiner(min1, min2, max1, max2)
    --[[
    Clamps: (min,max)
    --> (2, 5) (0, 4) (1, 3)
    Should output --> (2,3)
    ]]
    min1 = max(min1, min2)
    max1 = min(max1, max2)
    return min1, max1
end

umg.defineQuestion("properties:getPropertyClamp", clampCombiner)

