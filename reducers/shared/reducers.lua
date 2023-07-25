

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



function reducers.ADD_VECTOR(x1,x2, y1,y2)
    --[[
        combines vectors together by adding.
        (Only works when the answers return 2 numbers.)

        For example:

        umg.answer("getOffset", function()
            return x, y
        end)
    ]]
    return x1 + x2, y1 + y2
end

function reducers.MULT_VECTOR(x1,x2, y1,y2)
    --[[
        combines vectors together by multiplying.
        (Only works when the answers return 2 numbers.)
    ]]
    return x1 * x2, y1 * y2
end



function reducers.PRIORITY(a, b, prio_a, prio_b)
    --[[
        Treats the 2nd argument as the priority.
        Returns the answer with the highest priority.
        (If priorities are equal, returns the most recently defined answer)
    ]]
    if (prio_a or 0) > (prio_b or 0) then
        return a, prio_a
    end
    return b, prio_b
end



function reducers.PRIORITY_VECTOR(x1,x2, y1,y2, prio_1, prio_2)
    if (prio_1 or 0) > (prio_2 or 0) then
        return x1, y1, prio_1
    end
    return x2, y2, prio_2
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



function reducers.FIRST(a, b)
    --[[
        returns the FIRST non-nil result
        (This will be the first umg.answer that is loaded)
    ]]
    if a then
        return a
    end
    return b
end


function reducers.LAST(a, b)
    --[[
        returns the LAST non-nil result
        (This will be the last umg.answer that is loaded)

        If you want a definitive answer to a question, 
        (i.e. a question where results can't really be combined,)
        this is probably the best reducer to use.
    ]]
    if b then
        return b
    end
    return a
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
