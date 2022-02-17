
--[[

Handles animations of entities.

TODO:
Currently, all animation entities have the exact same

]]

local anim_group = group("draw", "animation")



local tick = 0

local DEFAULT_ANIM_SPEED = 2 -- seconds to complete animation loop

local EPSILON = 0.00001

local function updateEnt(ent)
    local anim = ent.animation
    local spd = anim.speed or DEFAULT_ANIM_SPEED
    local len = #anim

    local frame_i = math.floor(((tick % spd) / spd) * len - EPSILON)
    local frame = anim[frame_i]
    ent.draw = frame
end


on("update", function(dt)
    tick = tick + dt
    for i=1, #anim_group do
        local ent = anim_group[i]
        updateEnt(ent)
    end
end)

