
--[[
    testing sync mods auto component sync api
]]

local allGroup = umg.group()

return function()
    zenith.clear()

    -- testing syncing strings
    sync.autoSyncComponent("stringComponent")

    -- testing syncing numbers, with sync threshold 0.5
    sync.autoSyncComponent("numberComponent", {
        numberSyncThreshold = 0.5
    })

    -- test without delta compression
    sync.autoSyncComponent("numberComponentNoDelta", {
        noDeltaCompression = true
    })


    local ent
    if server then
        ent = server.entities.empty()
    end

    zenith.tick(2)

    if server then
        ent.stringComponent = "abc"
        ent.numberComponent = 1
        ent.numberComponentNoDelta = 150.0
    end

    zenith.tick(2)

    -- then we all good!
    if client then
        -- there's only 1 entity that exists
        ent = allGroup[1]
        zenith.assert(ent.stringComponent == "abc")
        zenith.assert(ent.numberComponent == 1)
        zenith.assert(ent.numberComponentNoDelta == 150.0)
    end

    local NUM = 150.0001
    if server then
        ent.stringComponent = "foo"
        ent.numberComponent = 1.0001
        ent.numberComponentNoDelta = NUM
    end

    zenith.tick(2)

    if client then
        zenith.assert(ent.stringComponent == "foo")
        zenith.assert(ent.numberComponent == 1)
        -- it's terrible to compare floats like this, but it should be "fine" in this case
        zenith.assert(ent.numberComponentNoDelta == NUM)
    end
end

