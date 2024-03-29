
local entGroup = umg.group("mycomp")


local NUM = 3


local function beforeEach()
    zenith.clear()
    zenith.tick(2)
    if server then
        local dummy = server.entities.empty()
        dummy.isDummy = true

        for _=1,NUM do
            local e = server.entities.empty()
            e.mycomp = "hello there"
            e.ref = dummy
        end
    end
    zenith.tick(2)
end


local function testShallowClone()
    beforeEach()

    local sze = entGroup:size()

    if server then
        for _, ent in ipairs(entGroup)do
            ent:shallowClone()
        end
    end

    zenith.tick(4)

    -- expect the entGroup size to have doubled
    zenith.assert(sze * 2, entGroup:size(), "shallowClone group size")

    local dummy = entGroup[1].ref
    zenith.assert(dummy.isDummy, "dummy was not valid somehow")
    for _, ent in ipairs(entGroup)do
        zenith.assert(ent.ref == dummy, "entity didn't reference dummy")
    end
end



local function testDeepClone()
    beforeEach()

    local sze = #entGroup

    if server then
        for _, ent in ipairs(entGroup)do
            -- clone twice, and then delete the original
            ent:deepClone()
            ent:deepClone()
            ent:delete()
        end
    end

    zenith.tick()
    zenith.tick()

    -- expect the entGroup size to have doubled
    zenith.assertEquals(sze * 2, entGroup:size(), "deepClone group size")

    local seenDummys = {}
    for _, ent in ipairs(entGroup)do
        local dummy = ent.ref
        if seenDummys[dummy] then
            print(seenDummys[dummy])
            print(ent)
            zenith.fail("dummy wasn't deepcopied!")
        end
        zenith.assert(umg.exists(dummy) and dummy.isDummy, "deepClone: entity didn't reference dummy")
        seenDummys[dummy] = ent
    end
end




local function testDeepDelete()
    beforeEach()

    local empty2
    if server then
        empty2 = server.entities.empty()
        empty2.arr = {}

        for _, ent in ipairs(entGroup) do
            table.insert(empty2.arr, ent)
        end
    end

    zenith.tick()

    if server then
        empty2:deepDelete()
    end

    zenith.tick(2)

    zenith.assert(entGroup:size() == 0, "Nested entities not deleted")
end



return function()
    testShallowClone()

    testDeepClone()
    
    testDeepDelete()
end

