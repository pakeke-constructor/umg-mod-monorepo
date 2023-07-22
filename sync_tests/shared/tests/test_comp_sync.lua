
--[[
    testing sync mods auto component sync api
]]

local allGroup = umg.group()


local EPSILON = 0.001
local function roughlyEqual(a, b)
    return math.abs(a - b) < EPSILON
end


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

    -- test with number lerp
    sync.autoSyncComponent("numberComponentLerp", {
        lerp = true
    })

    local max_speed = 5
    -- test bidirectional component
    sync.autoSyncComponent("bidirectionalComponent", {
        bidirectional = {
            shouldAcceptServerside = function(ent, val)
                return type(val) == "number" and math.abs(ent.bidirectionalComponent - val) < max_speed
            end,
            shouldForceSyncClientside = function(ent, val)
                return math.abs(ent.bidirectionalComponent - val) < max_speed
            end
        }
    })

    umg.on("isControllable", function(ent, user)
        -- For this test, any entity with a controllable component is
        -- controllable by ANY user.
        return ent.controllable
    end)


    local ent
    local ent2
    if server then
        ent = server.entities.empty()
        ent2 = server.entities.empty()
    end

    zenith.tick(2)

    if server then
        ent.stringComponent = "abc"
        ent.numberComponent = 1
        ent.numberComponentNoDelta = 150.0
        ent.numberComponentLerp = 5.0
        ent.bidirectionalComponent = 50
        ent.controller = true

        ent2.bidirectionalComponent = 50
    end

    zenith.tick(2)

    -- then we all good!
    if client then
        -- there's only 2 entities
        ent = allGroup[1]
        ent2 = allGroup[2]
        -- TODO: This ^^^^ is fucking dumb!!!!
        zenith.assert(ent.stringComponent == "abc", "string component")
        zenith.assert(ent.numberComponent == 1, "number component")
        zenith.assert(ent.numberComponentNoDelta == 150.0, "number component, no delta")
        zenith.assert(roughlyEqual(ent.numberComponentLerp, 5.0), "number component, no lerp")
        zenith.assert(ent.bidirectionalComponent == 50, "bidirectional component 1")
        zenith.assert(ent2.bidirectionalComponent == 50, "bidirectional component 2")
    end

    local NUM = 150.0001
    if server then
        ent.stringComponent = "foo"
        ent.numberComponent = 1.0001
        ent.numberComponentNoDelta = NUM
        ent.numberComponentLerp = 10
    end

    zenith.tick(1)

    if client then
        zenith.assert(ent.stringComponent == "foo", "string component 2")
        zenith.assert(ent.numberComponent == 1, "number component 2")
        -- it's terrible to compare floats like this, but it should be "fine" in this case
        zenith.assert(ent.numberComponentNoDelta == NUM, "number component, no delta 2")
        zenith.assert(ent.numberComponentLerp < 10, "number component, no lerp 2")
    end
end

