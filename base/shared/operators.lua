
local Array = data.Array


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


function operators.ADD(a,b)
    return a + b
end

operators.SUM = operators.ADD


function operators.MULT(a,b)
    return a * b
end



operators.MIN = math.min

operators.MAX = math.max


function operators.COLLECT(a, b)
    --[[
        Reducer function that collects all inputs into an array.
    ]]
    local ret = a
    if getmetatable(ret) ~= Array then
        ret = Array()
        ret:add(a)
    end
    ret:add(b)
end



function operators.TRUTHY()
    return true
end

function operators.FALSEY()
    return false
end


return operators
