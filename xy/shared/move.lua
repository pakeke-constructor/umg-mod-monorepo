

local moveGroup = umg.group("x", "y", "vx", "vy")

local options = require("shared.options")
local constants = require("shared.constants")




moveGroup:onAdded(function(ent)
    ent.vx = ent.vx or 0
    ent.vy = ent.vy or 0
    if ent.vz ~= nil then
        ent.vz = ent.vz or 0
    end
end)


local function doFriction(ent, dt)
    local fric = (ent.friction or options.DEFAULT_FRICTION)
    local divisor = 1 + fric * dt
    ent.vx = ent.vx / divisor
    ent.vy = ent.vy / divisor
end



local function shouldMove(ent)
    local blocked = umg.ask("isMovementDisabled", reducers.OR, ent)
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
    if ent.z then
        ent.z = ent.z + (ent.vz or 0) * dt
    end
end



umg.on("gameUpdate", function(dt)
    for _, ent in ipairs(moveGroup) do
        updateEnt(ent, dt)
    end
end)



