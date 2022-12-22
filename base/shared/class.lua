



local name_to_class = {
--[[
    [class_name] = class
]]
}



local function newObj(class, ...)
    local obj = {}
    setmetatable(obj, class)
    obj:init(...)
    return obj
end


local default_class_mt = {__call = newObj}


local function newClass(name, extends)
    if type(name) ~= "string" then
        error("class(name) expects a string as first argument")
    end
    if name_to_class[name] then
        error("duplicate class name: " .. name)
    end

    local class = {}
    class.__index = class

    if extends then
        if type(extends) ~= "table" then
            error("class(name, extends) expects a class as optional 2nd argument")
        end
        setmetatable(class, {
            __index = extends,
            __call = newObj
        })
    else
        setmetatable(class, default_class_mt)
    end

    umg.register(class, name)
    return class
end




return newClass

