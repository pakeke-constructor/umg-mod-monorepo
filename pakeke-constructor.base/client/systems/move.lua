

local moveEnts = group("x", "y", "vx", "vy")

local constants = require("client.constants")

local DEFAULT_FRICTION = constants.DEFAULT_FRICTION



local FRICTION_CONSTANT = 38
-- I put this constant in here to make friction higher, and more consistent
-- with Box2d, since they do it differently.
-- (Why this number exactly? idk, it just "felt right", haha)


local function doFriction(ent, dt)
    local divisor = 1 + (ent.friction or DEFAULT_FRICTION) * FRICTION_CONSTANT * dt
    ent.vx = ent.vx / divisor
    ent.vy = ent.vy / divisor
end



local function updateEnt(ent, dt)
    -- We don't move entities if they are being handled by physics system
    if not ent.physics then
        doFriction(ent, dt)
        ent.x = ent.x + ent.vx * dt
        ent.y = ent.y + ent.vy * dt
    end
end



on("update", function(dt)
    for _, ent in ipairs(moveEnts) do
        updateEnt(ent, dt)
    end
end)

