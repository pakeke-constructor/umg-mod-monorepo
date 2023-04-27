
local Array = require("shared.array")


local operators = {}
--[[

These are mainly supposed to be used with the umg.ask() function,
as the reducer.

]]

function operators.OR(a,b)
    return a or b
end


function operators.AND(a,b)
    return a and b
end


function operators.EXISTS(a,b)
    --[[
        takes two inputs a,b
        returns the one that is a valid umg entity.
    ]]
    if umg.exists(a) then
        return a
    end
    return b
end


function operators.COLLECT(a, b)
    --[[
        Collects all inputs into an array.
    ]]
    local ret = a
    if getmetatable(ret) ~= Array then
        ret = Array()
        ret:add(a)
    end
    ret:add(b)
end


return operators
