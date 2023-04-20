
local zenith = require("shared.zenith")



local tests = {
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
local clientSentReady = false


local waitTicks = 1
local WAIT_N = 60 -- wait X ticks for client to join.


umg.on("@tick", function()
    if not tests[i] then
        return
    end

    if server and waitTicks < WAIT_N then
        -- wait for client to join
        waitTicks = waitTicks + 1
        return
    end

    if zenith.readyForNextTest() then
        if server and clientReady then
            local tst = tests[i]
            clientReady = false
            server.broadcast("zenithNextTest", i)
            zenith.run(tst)
            i = i + 1
        elseif client and (not clientSentReady) then
            clientSentReady = true
            client.send("zenithReady")
        end
    end

    if zenith.getTest() then
        local res, err = zenith.resume()
        if not res then
            print("[zenith] FAIL: ", err)
            zenith.fail()
        end
    end
end)


if client then
    client.on("zenithNextTest", function(index)
        clientSentReady = false
        local tst = tests[index]
        zenith.run(tst)
    end)
end


if server then
    server.on("zenithReady", function()
        clientReady = true
    end)
end


