
local zenith = require("shared.zenith")



local tests = {
    "an_example"
}


for i, test in ipairs(tests)do
    local func = require("shared.tests." .. test)
    tests[i] = {
        testFunction = func,
        testName = test
    }
end



local i = 1

umg.on("@tick", function()
    if zenith.nextTest() and tests[i] then
        local tst = tests[i]
        if tst then
            zenith.test(tst.testName, tst.testFunction)
        end
        i = i + 1
    end
end)


