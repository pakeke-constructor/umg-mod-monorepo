
local zenith = {}


local currentTestName = "nil"
local currentTestCoroutine = nil


function zenith.tick()
    if currentTestCoroutine then
        coroutine.resume(currentTestCoroutine)
    end
end



function zenith.name(name)
    currentTestName = name
end


function zenith.assert(bool, err)
    if not bool then
        print("[zenith] FAIL: ", currentTestName, " with error: ", err)
    end
end


function zenith.tick(ticks)
    ticks = ticks or 1
    for _=1, ticks do
        coroutine.yield()
    end
end


function zenith.test(func)
    local co = coroutine.create(func)
    currentTestCoroutine = co

    coroutine.resume(co)
end



function zenith.nextTest()
    if not currentTestCoroutine then
        return true
    end
    return coroutine.status(currentTestCoroutine) == "dead"
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

