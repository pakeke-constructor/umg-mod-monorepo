
--[[

Handles player control


]]

local control_ents = group("controllable", "controller")


local UP = "w"
local LEFT = "a"
local DOWN = "s"
local RIGHT = "d"

local LEFT_ABILITY = "q"
local RIGHT_ABILITY = "e"



local function pollControlEnts(func_key, a,b,c)
    for _, ent in ipairs(control_ents) do
        if ent.controller == username then
            -- if this ent is being controlled by the player:
            if ent.controllable[func_key] then
                -- and if the callback exists:
                ent.controllable[func_key](ent, a,b,c)
            end
        end
    end
end


on("keypressed", function(key, scancode)
    if scancode == LEFT_ABILITY then
        pollControlEnts("onLeftAbility")
    end
    if scancode == RIGHT_ABILITY then
        pollControlEnts("onRightAbility")
    end
end)



on("mousepressed", function(butto, x, y)
    -- TODO: This aint working!!! Maybe it's mousedown??? idk 
    if butto == 1 then
        pollControlEnts(nil, "onClick", x, y)
    end
end)


local isDown = keyboard.isScancodeDown


local DEFAULT_SPEED = 200

local SPEED_AGILITY_SCALE = 12


local max, min = math.max, math.min

local function updateEnt(ent, dt)
    local speed = ent.speed or DEFAULT_SPEED
    local agility = ent.agility or (speed * SPEED_AGILITY_SCALE)
    local delta = agility * dt

    if isDown(UP) then
        ent.vy = max(-speed, ent.vy - delta)
    end
    if isDown(DOWN) then
        ent.vy = min(speed, ent.vy + delta)
    end
    if isDown(LEFT) then
        ent.vx = max(-speed, ent.vx - delta)
    end
    if isDown(RIGHT) then
        ent.vx = min(speed, ent.vx + delta)
    end
end




local function follow_avg(sum_x, sum_y, len)
    --[[
        follows the camera based on average positions
    ]]
    local avg_x, avg_y = 0, 0
    if len > 0 then
        avg_x = sum_x / len
        avg_y = sum_y / len
    end
    base.camera:follow(avg_x, avg_y)
end


on("update", function(dt)
    local sum_x = 0
    local sum_y = 0
    local len = 0
    local has_follow = false
    
    for _, ent in ipairs(control_ents) do
        if ent.controller == username and ent.x and ent.vx then
            updateEnt(ent, dt)
            if ent.follow then
                has_follow = true
                sum_x = sum_x + ent.x
                sum_y = sum_y + ent.y
                len = len + 1
            end
        end
    end

    if has_follow then
        follow_avg(sum_x, sum_y, len)
    end
end)



--[[
    When we recieve a `tick` from the server,
    send the server our player's position.
    (Note that the server can choose to deny our player position 
      if it thinks we are cheating!!!)
]]
on("tick", function(dt)
    for i=1, #control_ents do
        local ent = control_ents[i]
        if ent.controller == username then
            client.send("setPlayerPosition", ent, ent.x, ent.y, ent.z)
            if ent.vx and ent.vy then
                client.send("setPlayerVelocity", ent, ent.vx, ent.vy, ent.vz)
            end
        end
    end
end)

