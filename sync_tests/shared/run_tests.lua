

local tests = {
    "test_comp_sync",
}


for _, test in ipairs(tests)do
    local tes = require("shared.tests." .. test)
    zenith.defineTest({
        test = tes,
        name = test
    })
end


zenith.runTests()

