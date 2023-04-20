
local zenith = {}



local currentTest = nil





function zenith.assert(bool, err)
    err = err or "(none)"
    if not bool then
        print("[zenith] FAIL: ", currentTest.name, " with error: ", err)
        currentTest.failed = true
    end
end


function zenith.resume()
    return coroutine.resume(currentTest.co)
end


function zenith.tick(ticks)
    ticks = ticks or 1
    for _=1, ticks do
        coroutine.yield()
    end
end


function zenith.fail()
    currentTest.failed = true
end


function zenith.getTest()
    return currentTest
end


function zenith.test(options)
    assert(type(options.name) == "string" and type(options.func) == "function", "?")
    options.failed = false

    options.co = coroutine.create(options.func)
    return options
end


function zenith.run(test)
    if currentTest then
        if currentTest.failed then
            -- output state of previous test
            print("[zenith] TEST FAILED: ", currentTest.name)
        else
            print("[zenith] TEST PASSED", currentTest.name)
        end
    end

    assert(zenith.readyForNextTest(),"?")
    assert(test.co, "?")
    currentTest = test
    coroutine.resume(test.co)
end



function zenith.readyForNextTest()
    if not currentTest then
        return true
    end
    return coroutine.status(currentTest.co) == "dead"
end





local allGroup = umg.group()


function zenith.clear()
    if not server then return end

    for _, ent in ipairs(allGroup)do
        ent:delete()
    end
    zenith.tick()
end


function zenith.allGroup()
    return allGroup
end



return zenith

