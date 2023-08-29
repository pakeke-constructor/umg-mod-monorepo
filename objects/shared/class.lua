
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



local function isChildOf(child, parent)
    --[[
        returns true iff `child` is a child of `parent`
    ]]
    if child == parent then
        return true
    end

    if child._extends then
        return isChildOf(child._extends, parent)
    end
end

local function isInstance(x, class)
    --[[
        checks if `x` is an instance of `class`
    ]]
    if type(x) ~= "table" then
        return false
    end
    local cls = getmetatable(x)
    return isChildOf(cls, class)
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
        assert(x ~= class, "Call like Cls.isInstance(x), not Cls:isInstance(x)")
        return isInstance(x, class)
    end

    if extends then
        if type(extends) ~= "table" then
            error("class(name, extends) expects a class as optional 2nd argument")
        end
        if isChildOf(extends, class) then
            error("Cannot inherit from this class!")
        end
        class._extends = extends
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


local test = true

if test then
--[[
a instanceof A --> true
b instanceof B --> true

b instanceof A --> true
a instanceof B --> false
]]
local A = newClass("objects:test:A")
local B = newClass("objects:test:B", A) -- B extends A

local a = A()
local b = B()

assert(A.isInstance(a))
assert(B.isInstance(b))

assert(A.isInstance(b))
assert(not B.isInstance(a), "?")
print("[objects] Inheritance test passed")
end




return newClass

