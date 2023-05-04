

local tests = {
    "test_control_movement",
}


for _, test in ipairs(tests)do
    local tes = require("shared.tests." .. test)
    zenith.defineTest({
        test = tes,
        name = test
    })
end


zenith.runTests()

