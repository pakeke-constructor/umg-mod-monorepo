

local typecheck = {}


local type = type
local floor = math.floor
local select = select



function typecheck.int(x)
    return (type(x) == "number") and floor(x) == x, "expected integer, (not float!)"
end
typecheck.integer = typecheck.int


function typecheck.num(x)
    return type(x) == "number", "expected number"
end
typecheck.number = typecheck.num


function typecheck.string(x)
    return type(x) == "string", "expected string"
end
typecheck.str = typecheck.string


function typecheck.table(x)
    return type(x) == "table",  "expected table"
end


function typecheck.func(x)
    return type(x) == "function", "expected function"
end
typecheck["function"] = typecheck.func
typecheck.fn = typecheck.func



function typecheck.entity(x)
    return umg.exists(x), "expected entity"
end
typecheck.ent = typecheck.entity



function typecheck.optional(f)
    return function(x)
        return x == nil or f(x)
    end
end






local function parseToFunction(str)
    if str:find("%?") then
        -- if string contains question mark, treat the argument as optional.
        str = str:gsub("%?","")
        if typecheck[str] then
            return typecheck.optional(typecheck[str])
        end
    elseif typecheck[str] then
        return typecheck[str]
    end
end


local function parseArgCheckers(arr)
    for i=1, #arr do
        if type(arr[i]) == "string" then
            arr[i] = parseToFunction(arr[i])
        end
        assert(type(arr[i]) == "function", ("Type checker definition error: arg %d is not a valid typecheck function"):format(i))
    end
end



function typecheck.assert(...)
    local check_fns = {...}
    parseArgCheckers(check_fns)

    return function(...)
        for i=1, #check_fns do
            local arg = select(i, ...)
            local ok, err = check_fns[i](arg)
            if not ok then
                local estring = "Bad argument #" .. tostring(i) .. ":\n"
                local err_data = tostring(arg) .. " was given, but " .. tostring(err) 
                error(estring .. err_data, 3)
            end
        end
    end
end


function typecheck.check(...)
    local check_fns = {...}
    parseArgCheckers(check_fns)

    return function(...)
        for i=1, #check_fns do
            local arg = select(i, ...)
            local ok, err = check_fns[i](arg)
            if not ok then
                return false, err
            end
        end
        return true
    end
end


return typecheck
