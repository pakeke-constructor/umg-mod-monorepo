

local function filterNotFound(t,k)
    error("Unknown filter: " .. tostring(k))
end


local validFilters = {
    -- [filterFunc] -> true
}

local filterAPI = {
    filters = setmetatable({}, {__index = filterNotFound})
}


local defineFilterTc = typecheck.assert("string", "function")

function filterAPI.defineFilter(filterName, checkFunc)
    defineFilterTc(filterName, checkFunc)
    assert(not filterAPI.filters[filterName], "Overwriting existing filter!")
    filterAPI.filters[filterName] = checkFunc
    validFilters[checkFunc] = true
end

function filterAPI.filter(...)
    local check_fns = {...}
    for _, f in ipairs(check_fns)do
        assert(type(f) == "function", "filter must be a function")
    end

    return function(sender, ...)
        for i=1, #check_fns do
            local arg = select(i, ...)
            local ok = check_fns[i](sender, arg)
            if not ok then
                return false
            end
        end
    end
end


local numbers2Tc = typecheck.assert("number", "number")
local funcs2Tc = typecheck.assert("function", "function")

local defaults = {
    number = function(sender, x) return type(x) == "number" end,
    string = function(sender, x) return type(x) == "string" end,
    table = function(sender, x) return type(x) == "table" end,
    entity = function(sender, x) return umg.exists(x) end,
    controlEntity = function(sender, x) return umg.exists(x) and x.controller == sender end,

    NumberInRange = function(lower, upper)
        numbers2Tc(lower, upper)
        return function(sender, x)
            return type(x) == "number" and (x >= lower) and (x <= upper)
        end
    end,

    And = function(f1, f2)
        funcs2Tc(f1,f2)
        return function(sender, x)
            return f1(sender, x) and f2(sender, x)
        end
    end
}

for filterName, filterVal in pairs(defaults)do
    filterAPI.defineFilter(filterName, filterVal)
end



return filterAPI
