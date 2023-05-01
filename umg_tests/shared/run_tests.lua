

local tests = {
    "component_rem_add",
    "broadcast"
}


for i, test in ipairs(tests)do
    local tes = require("shared.tests." .. test)
    zenith.defineTest({
        test = tes,
        name = test
    })
end


zenith.runTests()
