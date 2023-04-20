

local function addComp()
    local e
    if server then
        e = server.entities.empty()
    end

    zenith.tick()
    if server then
        e.foo = 123
    end

    zenith.tick()
    zenith.assert(e.foo == 123, "addComponent")
end



local function removeComp()
    local N = 10
    local appleGroup = umg.group("apple")

    if server then
        for _=1, N do
            local e = server.entities.empty()
            e.apple = "foo"
        end
    end

    zenith.assert(#appleGroup == 0, "?")
    zenith.tick(1)
    zenith.assert(#appleGroup == N, "?")

    if server then
        for _, e in ipairs(zenith.allGroup()) do
            e:removeComponent("apple")
        end
    end

    zenith.tick(1)
    zenith.assert(#appleGroup == 0, "?")
end


local function addThenRemoveInstant()
    local N = 10
    local appleGroup = umg.group("apple")

    if server then
        for _=1, N do
            local e = server.entities.empty()
            e.apple = "foo"
            e:removeComponent("apple")
        end
    end

    zenith.tick(1)
    zenith.assert(#appleGroup == 0, "apple group wasn't empty")
end



return function()
    zenith.clear()
    addComp()

    zenith.clear()
    removeComp()

    zenith.clear()
    addThenRemoveInstant()
    
    zenith.tick()
end


