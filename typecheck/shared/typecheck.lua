

local typecheck = {}


local type = type
local floor = math.floor
local select = select


function typecheck.any()
    return true
end


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


function typecheck.boolean(x)
    return type(x) == "boolean", "expected boolean"
end
typecheck.bool = typecheck.boolean



function typecheck.entity(x)
    return umg.exists(x), "expected entity"
end
typecheck.ent = typecheck.entity



function typecheck.optional(f)
    return function(x)
        return x == nil or f(x)
    end
end




local parseToFunction -- need to define here for mutual recursion


local function parseUnion(str)
    local s = str:find("|")
    local type1 = str:sub(1,s-1)
    local type2 = str:sub(s+1)
    local f1 = parseToFunction(type1)
    local f2 = parseToFunction(type2)
    return function(x)
        local ok1, er1 = f1(x)
        local ok2, er2 = f2(x)
        if ok1 or ok2 then
            return true
        else
            return false, er1 .. " or " .. er2
        end
    end
end


function parseToFunction(str)
    str = str:gsub(" ","")

    if str:find("|") then
        return parseUnion(str)
    elseif str:find("%?") then
        -- if string contains question mark, treat the argument as optional.
        str = str:gsub("%?","")
        local func = parseToFunction(str)
        return typecheck.optional(func)
    elseif typecheck[str] then
        return typecheck[str]
    end
    error("malformed typecheck string: " .. tostring(str))
end



-- Must define here for mutual recursion
local makeCheckFunction


local function parseTableType(tableType)
    local keyList = {}
    local valueCheckers = {}

    for key, arg in pairs(tableType) do
        table.insert(keyList, key)
        local er0
        valueCheckers[key], er0 = makeCheckFunction(arg)
        if not valueCheckers[key] then
            error("Couldn't create typecheck function for key: " .. key .. " : " .. er0)
        end
    end

    local function check(x)
        local typeOk, er1 = typecheck.table(x) 
        if not typeOk then
            return nil, er1
        end

        for _, key in ipairs(keyList) do
            local val = x[key]
            local ok, err = valueCheckers[key](val)
            if not ok then
                return nil, "had bad value for '" .. tostring(key) .. "':\n" ..tostring(err)
            end
        end

        return true -- else, we are goods
    end

    return check
end



function makeCheckFunction(arg)
    if type(arg) == "string" then
        return parseToFunction(arg)
    end
    if type(arg) == "table" then
        return parseTableType(arg)
    end
    if type(arg) == "function" then
        return arg
    end
    return nil, tostring(arg) .. " is NOT a valid typecheck value! Must be either function, string, or table"
end



local function parseArgCheckers(arr)
    for i=1, #arr do
        local func, err = makeCheckFunction(arr[i])
        if not func then
            error(("Error during parsing typecheck arg num %d:\n"):format(i), tostring(err))
        end
        arr[i] = func
    end
end



local function makeError(arg, err, i)
    local estring = "Bad argument " .. tostring(i) .. ":\n"
    local err_data = tostring(type(arg)) .. " was given, but " .. tostring(err) 
    return estring .. err_data
end


function typecheck.assert(...)
    local check_fns = {...}
    parseArgCheckers(check_fns)

    return function(...)
        for i=1, #check_fns do
            local arg = select(i, ...)
            local ok, err = check_fns[i](arg)
            if not ok then
                error(makeError(arg, err, i), 3)
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
                return false, makeError(arg, err, i)
            end
        end
        return true
    end
end




return typecheck
