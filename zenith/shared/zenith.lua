
local zenith = {}

if server then
    -- must set it to a slow tickrate so client can keep up.
    server.setTickrate(1)
end




local currentTest = nil


local allTests = {} -- list of all tests


function zenith.test(options)
    assert(type(options.name) == "string" and type(options.func) == "function", "?")
    options.failures = {}

    options.co = coroutine.create(options.func)
    table.insert(allTests, options)
end



function zenith.fail(err)
    err = err or "(no error)"
    table.insert(currentTest.failures, err)
    currentTest.failed = true
end


function zenith.assert(bool, err)
    if not bool then
        zenith.fail(err)
    end
end



function zenith.tick(ticks)
    ticks = ticks or 1
    for _=1, ticks do
        coroutine.yield()
    end
end


local LINE = ("="):rep(50)

local function printResults()
    -- output state of previous test
    if currentTest.failed then
        print(LINE)
        print("[zenith] TEST FAILED: ", currentTest.name)
        print("[zenith] failure list:")
        for _, err in pairs(currentTest.failures) do
            print(currentTest.name .. " FAILURE:", err)
        end
        print(LINE)
    else
        print("[zenith] TEST PASSED", currentTest.name)
    end
end




local testing = false

function zenith.runTests()
    testing = true
end




local allGroup = umg.group()

function zenith.clear()
    if not server then return end

    for _, ent in ipairs(allGroup)do
        ent:delete()
    end
    zenith.tick()
end





local i = 1

local clientReady = true


local waitTicks = 1
local WAIT_N = 8 -- wait X ticks for client to join.


local function startNextTest(index)
    i = index
    local tst = allTests[i]
    if not tst then return end
    currentTest = tst
    clientReady = false
end



local function tryStartNextTest()
    if not server then
        return
    end
    if clientReady then
        startNextTest(i)
        server.broadcast("zenithNextTest", i)
        i = i + 1
        return true
    end
end


local function isTestDone()
    return coroutine.status(currentTest.co) == "dead"
end


local function finishTest()
    if client then
        client.send("zenithReady")
    end
    printResults()
    currentTest = nil
end



umg.on("@tick", function()
    if not testing then
        return
    end

    if server and waitTicks < WAIT_N then
        -- wait for client to join
        waitTicks = waitTicks + 1
        return
    end

    if not currentTest then
        if server then
            tryStartNextTest()
        end
        return
    end

    local co = currentTest.co
    if isTestDone() then
        -- completed test
        finishTest()
        return
    end

    local res, err = coroutine.resume(co)
    if not res then
        -- either test has completed, or there has been error.
        if err then
            zenith.fail(err)
        end
        finishTest()
    end
end)


if client then
    client.on("zenithNextTest", function(index)
        startNextTest(index)
    end)
end


if server then
    server.on("zenithReady", function()
        clientReady = true
    end)
end



_G.zenith = zenith

return zenith
