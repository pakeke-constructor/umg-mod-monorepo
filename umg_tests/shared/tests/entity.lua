
local appleGroup = umg.group("apple")


local NUM = 100

local function makeEnts()
    assert(server, "?")
    local dummy = server.entities.empty()
    dummy.isDummy = true

    for _=1,NUM do
        local e = server.entities.empty()
        e.apple = "hello there"
        e.ref = dummy
    end
end


local function testShallowClone()
    if server then
        makeEnts()
    end

    zenith.tick()

    local len = #appleGroup

    if server then
        for _, ent in ipairs(appleGroup)do
            ent:shallowClone()
        end
    end

    zenith.tick()
    zenith.tick()

    zenith.assert(#appleGroup == 2 * len, "not 2x size!")

    local dummy = appleGroup[1].ref
    zenith.assert(dummy.isDummy, "dummy was not valid somehow")
    for _, ent in ipairs(appleGroup)do
        zenith.assert(ent.ref == dummy, "entity didn't reference dummy")
    end
end



local function testDeepClone()
    if server then
        makeEnts()
    end

    zenith.tick()

    local len = #appleGroup

    if server then
        for _, ent in ipairs(appleGroup)do
            ent:deepClone()
        end
    end

    zenith.tick()
    zenith.tick()

    zenith.assert(#appleGroup == 2 * len, "deepClone: not 2x size!")

    local dummy = appleGroup[1].ref
    zenith.assert(dummy.isDummy, "deepClone: dummy was not valid somehow")
    for _, ent in ipairs(appleGroup)do
        zenith.assert(ent.ref ~= dummy, "deepClone: entity didn't reference dummy")
    end
end




local function testDeepDelete()
    makeEnts()

    local empty2
    if server then
        empty2 = server.entities.empty()
        empty2.arr = {}

        for _, ent in ipairs(appleGroup) do
            table.insert(empty2.arr, ent)
        end
    end

    zenith.tick()

    if server then
        empty2:deepDelete()
    end

    zenith.tick(2)

    zenith.assert(#appleGroup, "Nested entities not deleted")
end



return function()
    zenith.clear()

    testShallowClone()

    zenith.clear()

    testDeepClone()
    
    zenith.clear()

    testDeepDelete()

    zenith.tick(2)
end

