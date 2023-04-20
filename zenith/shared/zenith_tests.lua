
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



local i = 0

umg.on("@tick", function()
    if zenith.nextTest() and tests[i] then
        i = i + 1
        local tst = tests[i]
        if tst then
            zenith.test(tst)
        end
    end
end)


