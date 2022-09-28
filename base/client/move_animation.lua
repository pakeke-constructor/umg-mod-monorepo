
--[[

Handles moving animation of entities.

TODO:
Currently, all move animation entities have the exact same cycle.
Change this by having a table that maps `[ent] --> current_cycle` 
to offset each entity animation

]]



local anim_group = group("image", "moveAnimation", "vx", "vy")



local tick = 0

local DEFAULT_ANIM_SPEED = 2 -- seconds to complete animation loop

local DEFAULT_ANIM_ACTIVATION_SPEED = 5

local ent_to_direction = {
    --[[
        [ent] = current_direction_of_this_ent
    ]]
}

--[[
    directions are as follows:
    `up`, `down`, `left`, `right`
]]




anim_group:onAdded(function(ent)
    ent_to_direction[ent] = "down"
end)


anim_group:onRemoved(function(ent)
    ent_to_direction[ent] = nil
end)




local distance = math.distance
local abs = math.abs
local min = math.min
local floor = math.floor


local function getDirFromSpeed(ent)
    if abs(ent.vx) > abs(ent.vy) then
        -- Left or Right
        if ent.vx < 0 then
            return "left"
        else
            return "right"
        end
    else
        -- up or down
        if ent.vy < 0 then
            return "up"
        else
            return "down"
        end
    end
end



local function getDirection(ent, entspeed)
    local manim = ent.moveAnimation
    if entspeed > manim.activation then
        local dir = ent.faceDirection
        if not dir then
            dir = getDirFromSpeed(ent)
        end
        ent_to_direction[ent] = dir
        return dir
    else
        -- The entity is not going fast enough;
        -- return it's previous direction
        return ent_to_direction[ent]
    end
end




local function updateEnt(ent)
    local manim = ent.moveAnimation
    local entspeed = distance(ent.vx, ent.vy)
    
    local dir = getDirection(ent, entspeed) -- should be up, down, left, or right
    local spd = manim.speed or DEFAULT_ANIM_SPEED

    local anim = ent.moveAnimation[dir]
    -- TODO: Chuck an assertion here to ensure that people aren't misusing
    -- the moveAnimation component. (all directions must be defined)
    local len = #anim

    if entspeed > (manim.activation or DEFAULT_ANIM_ACTIVATION_SPEED) then
        local frame_i = min(len, floor(((tick % spd) / spd) * len) + 1)
        local frame = anim[frame_i]
        ent.image = frame
    else
        ent.image = anim[1]
    end
end


on("gameUpdate", function(dt)
    tick = tick + dt
    for i=1, #anim_group do
        local ent = anim_group[i]
        updateEnt(ent)
    end
end)

