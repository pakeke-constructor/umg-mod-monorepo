
require("xy_questions")


local moveGroup = umg.group("x", "y", "vx", "vy")

local options = require("shared.options")
local constants = require("shared.constants")



local function doFriction(ent, dt)
    local noFriction = umg.ask("xy:isFrictionDisabled", ent)
    if noFriction then
        return
    end

    local fric = (ent.friction or options.DEFAULT_FRICTION)
    local divisor = 1 + fric * dt
    ent.vx = ent.vx / divisor
    ent.vy = ent.vy / divisor
end


local function shouldMoveShared(ent)
    -- Allow future mods to disable velocity.
    -- This comes in handy when we want to have velocity components,
    -- but we don't want them to actually work. (i.e. physics system)
    local blocked = umg.ask("xy:isVelocityDisabled", ent)
    return not blocked
end





local shouldMove

if client then
-- On client-side, we only move entities if they are being controlled;
-- else, we let auto-sync handle it.

function shouldMove(ent)
    local ok = shouldMoveShared(ent)
    return ok and sync.isControlledBy(ent, client.getUsername())
end

elseif server then
-- On server-side, we do the opposite.
-- If an entity is being controlled; don't move it.
function shouldMove(ent)
    local ok = shouldMoveShared(ent)
    return ok and (not ent.controller)
end

end




local function shouldMoveZ(ent)
    if (not ent.z) or (not ent.vz) then
        return
    end
    local blocked = umg.ask("xy:isVerticalVelocityDisabled", ent)
    return not blocked
end




local function updateEnt(ent, dt)
    -- We don't move entities if they are being handled by physics system
    -- (although we do handle the Z component regardless)
    if shouldMove(ent) then
        doFriction(ent, dt)
        ent.x = ent.x + ent.vx * dt
        ent.y = ent.y + ent.vy * dt
    end

    if shouldMoveZ(ent) then
        ent.z = ent.z + ent.vz * dt
    end
end




--[[
    TODO: do we need `gameUpdate` on serverside?
    We could instead run this code every tick instead...
    clients won't see a difference.
]]
umg.on("state:gameUpdate", function(dt)
    for _, ent in ipairs(moveGroup) do
        updateEnt(ent, dt)
    end
end)

