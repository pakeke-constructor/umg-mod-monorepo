
--[[
    Testing controllable and control component
]]



local LEIGHWAY = 3

local function assertCloseTo(expected, got, err)
    local diff = math.abs(expected - got)
    zenith.assert(diff < LEIGHWAY, err)
end


local allGroup = umg.group()

return function()
    zenith.clear()

    local ent
    if server then
        ent = server.entities.player(0,0)
        ent.controller = server.getHostUsername()
    end

    zenith.tick(2)

    local TOTAL_X_DIST = 30
    local DIST_PER_STEP = 2
    local NUM_STEPS = TOTAL_X_DIST / DIST_PER_STEP

    for _=1, NUM_STEPS do
        if client then
            ent = allGroup[1]
            ent.x = ent.x + DIST_PER_STEP
        end
        zenith.tick()
    end

    zenith.tick()

    if server then
        assertCloseTo(0 + TOTAL_X_DIST, ent.x, "control entity didn't move")
    end
end

