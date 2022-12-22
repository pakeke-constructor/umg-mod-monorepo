

local moveEnts = umg.group("x", "y", "vx", "vy")

local constants = require("shared.constants")

local DEFAULT_FRICTION = constants.DEFAULT_FRICTION



local FRICTION_CONSTANT = constants.FRICTION_CONSTANT
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
    if ent.z then
        ent.z = ent.z + (ent.vz or 0) * dt
    end
end


client.on("changePosition", function(ent, x,y,z)
    if ent.controller == client.getUsername() then
        return
    end
    ent.x = x
    ent.y = y
    ent.z = z
end)


client.on("changeVelocity", function(ent, vx,vy,vz)
    if ent.controller == client.getUsername() then
        return
    end
    ent.vx = vx
    ent.vy = vy
    ent.vz = vz
end)



umg.on("gameUpdate", function(dt)
    for _, ent in ipairs(moveEnts) do
        if ent.controller == client.getUsername() then
            -- We only control the 
            updateEnt(ent, dt)
        end
    end
end)


moveEnts:onAdded(function(ent)
    ent.vx = ent.vx or 0
    ent.vy = ent.vy or 0
    if ent:isRegular("vz") then
        ent.vz = ent.vz or 0
    end
end)


local positionEnts = umg.group("x","y")

positionEnts:onAdded(function(ent)
    ent.x = ent.x or 0
    ent.y = ent.y or 0
    if ent:isRegular("z") then
        ent.z = ent.z or 0
    end
end)

