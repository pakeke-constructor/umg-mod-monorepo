
--[[
    testing sync mods auto component sync api
]]

local allGroup = umg.group()


local EPSILON = 0.001
local function roughlyEqual(a, b)
    return math.abs(a - b) < EPSILON
end



local max_speed = 5
-- test bidirectional component
sync.autoSyncComponent("bidirectionalComponent", {
    bidirectional = {
        shouldAcceptServerside = function(ent, val)
            return type(val) == "number" and math.abs(ent.bidirectionalComponent - val) < max_speed
        end,
        shouldForceSyncClientside = function(ent, val)
            return math.abs(ent.bidirectionalComponent - val) > max_speed * 2
        end
    }
})



return function()
    zenith.clear()

    local ent
    local ectrl
    if server then
        ent = server.entities.empty()
        ectrl = server.entities.empty()
    end

    zenith.tick(2)

    if server then
        ent.bidirectionalComponent = 50

        ectrl.bidirectionalComponent = 50
        ectrl.controllable = true
        ectrl.controller = server.getHostUsername()
    end

    zenith.tick(2)

    local delta = max_speed / 2
    if client then
        -- assign the entities:
        for _, e in ipairs(allGroup) do
            -- this is hacky. ITS FINE!
            if e.controllable then
                ectrl = e
            else
                ent = e
            end
        end

        zenith.assert(ent.bidirectionalComponent == 50, "bidirectional component 1")
        zenith.assert(ectrl.bidirectionalComponent == 50, "bidirectional component 2")
        
        ent.bidirectionalComponent = ent.bidirectionalComponent + delta
        ectrl.bidirectionalComponent = ectrl.bidirectionalComponent + delta
    end

    zenith.tick(1)

    if server then
        -- check that appropriate changes were seen on server:
        zenith.assert(ent.bidirectionalComponent == 50, "bidirectional component 3")
        zenith.assert(roughlyEqual(ectrl.bidirectionalComponent, 50 + delta), "bidirectional component 4")

        ectrl.bidirectionalComponent = 5000
        ent.bidirectionalComponent = 5000
    end

    zenith.tick(2)

    if client then
        -- check that a forceSync has gone through (ie. shouldForceSyncClientside was called)
        zenith.assert(ent.bidirectionalComponent == 5000, "bidirectional component 5")
        zenith.assert(ectrl.bidirectionalComponent == 5000, "bidirectional component 6")

        -- This packet should get denied, since the entity is moving too fast:
        ectrl.bidirectionalComponent = ectrl.bidirectionalComponent + max_speed * 1.5
    end

    zenith.tick(1)

    if server then
        zenith.assert(ectrl.bidirectionalComponent == 5000, "bidirectional component 7")
    end
end

