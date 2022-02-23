
--[[

Handles player control


]]

local control_ents = group("controllable")

local UP = "w"
local LEFT = "a"
local DOWN = "s"
local RIGHT = "d"

local LEFT_ABILITY = "q"
local RIGHT_ABILITY = "e"



local function pollControlEnts(func_key, a,b,c)
    for _, ent in ipairs(control_ents) do
        if ent.controllable.controller == username then
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
    if butto == 1 then
        pollControlEnts(nil, "onClick", x, y)
    end
end)


local isDown = keyboard.isScancodeDown


local DEFAULT_SPEED = 200


local max, min = math.max, math.min

local function updateEnt(ent, dt)
    local speed = ent.speed or DEFAULT_SPEED
    local agility = ent.agility or speed
    local delta = agility * dt

    if isDown(UP) then
        ent.vy = max(speed, ent.vy - delta)
    end
    if isDown(DOWN) then
        ent.vy = min(speed, ent.vy + delta)
    end
    if isDown(LEFT) then
        ent.vx = max(speed, ent.vx - delta)
    end
    if isDown(RIGHT) then
        ent.vx = min(speed, ent.vx + delta)
    end
end



on("update", function(dt)
    for _, ent in ipairs(control_ents) do
        if ent.controllable.controller == username then
            updateEnt(ent, dt)
        end
    end
end)

