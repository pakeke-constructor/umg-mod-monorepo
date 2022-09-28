

local moveEnts = group("x", "y", "vx", "vy")

local constants = require("shared.constants")

local DEFAULT_FRICTION = constants.DEFAULT_FRICTION


local FRICTION_CONSTANT = constants.FRICTION_CONSTANT
-- I put this constant in here to make friction higher, and more consistent
-- with Box2d, since they do it differently.
-- (Why this number exactly? idk, it just "felt right", haha)



moveEnts:onAdded(function(ent)
    if not (ent.x and ent.y) then
        error("Entity wasn't provided x,y values: " .. tostring(ent:type()))
    end 
    ent.vx = ent.vx or 0
    ent.vy = ent.vy or 0
    if ent.vz ~= nil then
        ent.vz = ent.vz or 0
    end
end)


local function doFriction(ent, dt)
    local divisor = 1 + (ent.friction or DEFAULT_FRICTION) * FRICTION_CONSTANT * dt
    ent.vx = ent.vx / divisor
    ent.vy = ent.vy / divisor
end



local function updateEnt(ent, dt)
    -- We don't move entities if they are being handled by physics system
    -- (although we do handle the Z component regardless)
    if not ent.physics then
        doFriction(ent, dt)
        ent.x = ent.x + ent.vx * dt
        ent.y = ent.y + ent.vy * dt
    end
    if ent.z then
        ent.z = ent.z + (ent.vz or 0) * dt
    end
end



on("gameUpdate", function(dt)
    for _, ent in ipairs(moveEnts) do
        updateEnt(ent, dt)
    end
end)



local SYNC_LEIGHWAY = constants.SYNC_LEIGHWAY

--[[
    These tables hold the last instance of x,y,z and vx,vy,vz values.
    Delta compression is used, so 
]]
local ent_to_x = setmetatable({}, {__index = function(tab, ent)
    tab[ent] = ent.x
    return ent.x
end})
local ent_to_y = setmetatable({}, {__index = function(tab, ent)
    tab[ent] = ent.y
    return ent.y
end})
local ent_to_z = {}

local ent_to_vx = setmetatable({}, {__index = function(tab, ent)
    tab[ent] = ent.vx or 0 -- defaults to 0
    return tab[ent]
end})
local ent_to_vy = setmetatable({}, {__index = function(tab, ent)
    tab[ent] = ent.vy or 0 -- defaults to 0
    return tab[ent]
end})
local ent_to_vz = {}


local abs = math.abs
local function difference(a, b)
    return abs(a - b)
end



local function syncNonMover(ent)
    local should_sync = false

    local last_x = ent_to_x[ent]
    if difference(last_x, ent.x) > SYNC_LEIGHWAY then
        should_sync = true
    end
    
    local last_y = ent_to_y[ent]
    if difference(last_y, ent.y) > SYNC_LEIGHWAY then
        should_sync = true
    end

    if ent.z then
        ent_to_z[ent] = ent_to_z[ent] or ent.z
        if difference(ent_to_z[ent], ent.z) > SYNC_LEIGHWAY then
            should_sync = true
        end
    end

    if should_sync then
        ent_to_x[ent] = ent.x
        ent_to_y[ent] = ent.y
        ent_to_z[ent] = ent.z
        server.broadcast("changePosition", ent, ent.x, ent.y, ent.z)
    end
end



local function shouldSyncVxVy(ent)
    local last_x = ent_to_vx[ent]
    local should_sync = false
    if difference(last_x, ent.vx) > SYNC_LEIGHWAY then
        should_sync = true
    end
    
    local last_y = ent_to_vy[ent]
    if difference(last_y, ent.vy) > SYNC_LEIGHWAY then
        should_sync = true
    end

    return should_sync
end


local function syncMover(ent)
    local should_sync = shouldSyncVxVy(ent) or true

    if ent.vz then
        local last_z = ent_to_vz[ent] or ent.vz
        ent_to_vz[ent] = ent.vz
        if difference(last_z, ent.vz) > SYNC_LEIGHWAY then
            should_sync = true
        end
    end

    if should_sync then
        ent_to_vx[ent] = ent.vx
        ent_to_vy[ent] = ent.vy
        ent_to_vz[ent] = ent.vz
        server.broadcast("changeVelocity", ent, ent.vx, ent.vy, ent.vz)
    end
end



local positionGroup = group("x", "y")


positionGroup:onAdded(function(ent)
    ent.x = ent.x or 0
    ent.y = ent.y or 0
    if (not ent.z) and ent:isRegular("z") then
        ent.z = 0
    end
end)



on("tick", function()
    for _, ent in ipairs(moveEnts) do
        syncMover(ent)
    end

    for _, ent in ipairs(positionGroup) do
        syncNonMover(ent)
    end
end)

