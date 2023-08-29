

local Class = require("shared.class")

local test = false

if test then
--[[
a instanceof A --> true
b instanceof B --> true

b instanceof A --> true
a instanceof B --> false
]]
local A = Class("objects:test:A")
local B = Class("objects:test:B", A) -- B extends A

local a = A()
local b = B()

assert(A.isInstance(a))
assert(B.isInstance(b))

assert(A.isInstance(b))
assert(not B.isInstance(a), "?")
print("[objects] Inheritance test passed")
end

