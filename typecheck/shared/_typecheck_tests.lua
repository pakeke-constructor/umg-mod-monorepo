

local typecheck = require("shared.typecheck")



local check1 = typecheck.check("str", "string", "number")


assert(not check1("h", "h", "h"), "?")
assert(check1("h", "h", 1), "?")


local optionsCheck = typecheck.check("number", {
    foo = "string",
    bar = {
        x = "number",
        y = "number"
    }
})


assert(optionsCheck(65, {
    foo = "hello",
    bar = {x = 1, y = 2}
})) 


do
local ok,err = optionsCheck(65, {
    foo = 32,
    bar = {x = 1, y = 2}
})
assert(not ok,err)
end


