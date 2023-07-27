
--[[

Basic class object.

Usage:

local MyClass = Class("class_name_foo") 
-- class_name_foo is used for serialization purposes.


function MyClass:init(a,b,c)
    print("obj instantiated with args: ", a,b,c)
end


function MyClass:method(arg)
    print("Hello, I am a method.")
    print(self, arg)
end



]]

local name_to_class = {
--[[
    [class_name] = class
]]
}


local function newObj(class, ...)
    local obj = {}
    setmetatable(obj, class)
    if type(obj.init) == "function" then
        obj:init(...)
    end
    return obj
end


local default_class_mt = {__call = newObj}



local function isInstance(x, class, extends)
    --[[
        checks if `x` is an instance of `class`
    ]]
    assert(x ~= class, "Call like Cls.isInstance(x), not Cls:isInstance(x)")
    if type(x) ~= "table" then
        return false
    end
    local mt = getmetatable(x)
    if mt == class then
        return true
    end
    if extends then
        return extends.isInstance and extends.isInstance(x)
    end
    return false
end




local function newClass(name, extends)
    if type(name) ~= "string" then
        error("class(name) expects a string as first argument")
    end
    if name_to_class[name] then
        error("duplicate class name: " .. name)
    end

    local class = {}
    class.__index = class

    function class.isInstance(x)
        return isInstance(x, class, extends)
    end

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

