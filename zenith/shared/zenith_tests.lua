
local zenith = require("shared.zenith")



local tests = {
    "an_example",
    "component_rem_add"
}


for i, test in ipairs(tests)do
    local func = require("shared.tests." .. test)
    tests[i] = zenith.test({
        func = func,
        name = test
    })
end


zenith.runTests()

