
local zenith = {}


local currentTestName = "nil"
local currentTestCoroutine = nil
local currentTestFailed = false


umg.on("@tick", function()
    if currentTestCoroutine then
        coroutine.resume(currentTestCoroutine)
    end
end)



function zenith.name(name)
    currentTestName = name
end


function zenith.assert(bool, err)
    if not bool then
        print("[zenith] FAIL: ", currentTestName, " with error: ", err)
        currentTestFailed = true
    end
end


function zenith.tick(ticks)
    ticks = ticks or 1
    for _=1, ticks do
        coroutine.yield()
    end
end


function zenith.test(name, func)
    assert(type(name) == "string" and type(func) == "function", "?")
    local co = coroutine.create(func)
    currentTestCoroutine = co
    currentTestFailed = false
    currentTestName = name

    coroutine.resume(co)
end



function zenith.nextTest()
    if not currentTestCoroutine then
        return true
    end
    if coroutine.status(currentTestCoroutine) == "dead" then
        if not currentTestFailed then
            print("[zenith] TEST PASSED: ", currentTestName)
        end
    end
end




local allGroup = umg.group()

function zenith.clear()
    for _, ent in ipairs(allGroup)do
        ent:delete()
    end
    zenith.tick()
end


function zenith.allGroup()
    return allGroup
end



return zenith

