

local reducers = {}
--[[

These are mainly supposed to be used with the umg.ask() function,
as the reducer.

]]

function reducers.OR(a,b)
    return a or b
end


function reducers.AND(a,b)
    return a and b
end


function reducers.EXISTS(a,b)
    --[[
        takes two inputs a,b
        returns the one that is a valid umg entity.
    ]]
    if umg.exists(a) then
        return a
    end
    return b
end


function reducers.ADD(a,b)
    return a + b
end

reducers.SUM = reducers.ADD


function reducers.MULT(a,b)
    return a * b
end



reducers.MIN = math.min

reducers.MAX = math.max



local UNIQUE_MT = {}


function reducers.MERGE_ARRAYS(arr_a, arr_b)
    assert(type(arr_a) == "table", "Should be a table!")
    assert(type(arr_b) == "table", "Should be a table!")

    local new = {}
    for i=1, #arr_a do
        table.insert(new, arr_a[i])
    end
    for i=1, #arr_b do
        table.insert(new, arr_b[i])
    end
    return new
end



function reducers.SINGLE_COLLECT(a, b)
    --[[
        Reducer function that collects all single inputs into an array.
        
        The way this works, is the first argument `a` is treated
        as an array.
        `a` is then continuously passed to the next arguments.
    ]]
    local ret = a
    if getmetatable(ret) ~= UNIQUE_MT then
        --[[
        this is kinda hacky lmao!
        Basically, we need to be able to add any type to the array.
        So we set a unique metatable (UNIQUE_MT)
        ]]
        ret = setmetatable({}, UNIQUE_MT)
        table.insert(ret, a)
    end
    table.insert(ret, b)
end




umg.expose("reducers", reducers)
