

local appleGroup = umg.group("apple")
local allGroup = umg.group()



local function addComp()
    local e
    if server then
        e = server.entities.empty()
    end

    zenith.tick(4)

    if server then
        e.foo = 123
    end

    zenith.tick(4)

    zenith.assert(#allGroup == 1, "allGroup size not 1?")
    for _, ent in ipairs(allGroup) do
        zenith.assert(ent.foo == 123, "addComponent: " .. tostring(ent))
    end
end



local function removeComp()
    local N = 10

    if server then
        for _=1, N do
            local e = server.entities.empty()
            e.apple = "foo"
        end
    end

    zenith.assert(#appleGroup == 0, "appleGroup size not 0")
    zenith.tick(4)
    zenith.assert(#appleGroup == N, "appleGroup size not N")

    if server then
        for _, e in ipairs(allGroup) do
            e:removeComponent("apple")
        end
    end

    zenith.tick(4)
    zenith.assert(#appleGroup == 0, "appleGroup size not 0 (2nd time)")
end


local function addThenRemoveInstant()
    local N = 10

    if server then
        for _=1, N do
            local e = server.entities.empty()
            e.apple = "foo"
            e:removeComponent("apple")
        end
    end

    zenith.tick(4)
    zenith.assert(#appleGroup == 0, "appleGroup size not 0 (3rd time)")
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


