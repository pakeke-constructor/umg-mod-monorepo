

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



-- TODO: Should we have the defaults (or 0) here?
-- It's (slightly) less efficient.
function reducers.ADD(a,b)
    return (a or 0) + (b or 0)
end

reducers.SUM = reducers.ADD


-- TODO: Should we have the defaults (or 1) here?
-- It's (slightly) less efficient.
function reducers.MULTIPLY(a,b)
    return (a or 1) * (b or 1)
end



function reducers.ADD_VECTOR(x1,x2, y1,y2)
    --[[
        combines vectors together by adding.
        (Answers must return 2 numbers)
    ]]
    return x1 + x2, y1 + y2
end

function reducers.MULTIPLY_VECTOR(x1,x2, y1,y2)
    --[[
        combines vectors together by multiplying.
        (Only works when the answers return 2 numbers.)
    ]]
    return x1 * x2, y1 * y2
end



-- default priority
local D_PRIO = -1

function reducers.PRIORITY(a, b, prio_a, prio_b)
    --[[
        Treats the 2nd answer-value as the priority.
        Returns the answer with the highest priority.

        The first argument can be any type- only the priority matters for resolution.

        (If priorities are equal, returns the most recently defined answer)

        If you want a definitive answer to a question, 
        (i.e. a question where results can't really be combined,)
        this is probably the best reducer to use.

        Example:
        -- answering image for an entity:
        umg.answer("getImage", function(ent)
            if ent.animation then
                -- return
                local img = ent.animation.frame
                local priority = 1
                return img, priority
            end
        end)
    ]]
    if (prio_a or D_PRIO) > (prio_b or D_PRIO) then
        return a, prio_a
    end
    return b, prio_b
end



function reducers.PRIORITY_DOUBLE(x1,x2, y1,y2, prio_1, prio_2)
    --[[
        same as PRIORITY, but for 2 arguments, not 1.

        Argument visualization:

        umg.answer(... function()
            return x1, y1, prio_1
        end)

        umg.answer(... function()
            return x2, y2, prio_2
        end)
    ]]
    if (prio_1 or D_PRIO) > (prio_2 or D_PRIO) then
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
