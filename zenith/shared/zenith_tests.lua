
local zenith = require("shared.zenith")



local tests = {
    "_wait_for_client_join",
    "an_example",
    "component_rem_add",
    "z"
}


for i, test in ipairs(tests)do
    local func = require("shared.tests." .. test)
    tests[i] = zenith.test({
        func = func,
        name = test
    })
end



local i = 1

local clientReady = true



umg.on("@tick", function()
    if zenith.readyForNextTest() then
        if server and clientReady then
            local tst = tests[i]
            if not tst then return end

            clientReady = false
            server.broadcast("zenithNextTest", i)
            zenith.run(tst)
            i = i + 1
        elseif client then
            client.send("zenithReady")
        end
    end
end)


if client then
    client.on("zenithNextTest", function(index)
        local tst = tests[index]
        zenith.run(tst)
    end)
end


if server then
    server.on("zenithReady", function()
        clientReady = true
    end)
end
