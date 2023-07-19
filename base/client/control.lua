
--[[

Handles player control


]]

local control = {}



local operators = require("shared.operators")
local input = require("client.input")


local controllableGroup = umg.group("controllable", "controller", "x", "y")



local listener = input.Listener({priority = -1})



local function pollControllableGroup(func_key,a,b,c)
    for _, ent in ipairs(controllableGroup) do
        if ent.controller == client.getUsername() then
            -- if this ent is being controlled by the player:
            if ent.controllable[func_key] then
                -- and if the callback exists:
                ent.controllable[func_key](ent, a,b,c)        
            end
        end
    end
end






function listener:keypressed(key, scancode, isrepeat)
    if state.getCurrentState() ~= "game" then
        return
    end

    local inputEnum = self:getInputEnum(scancode)

    if inputEnum == input.BUTTON_LEFT then
        pollControllableGroup("onLeftButton")
    elseif inputEnum == input.BUTTON_RIGHT then
        pollControllableGroup("onRightButton")
    elseif inputEnum == input.BUTTON_SPACE then
        pollControllableGroup("onSpaceButton")
    elseif inputEnum == input.BUTTON_1 then
        pollControllableGroup("onButton1")
    elseif inputEnum == input.BUTTON_2 then
        pollControllableGroup("onButton2")    
    elseif inputEnum == input.BUTTON_3 then
        pollControllableGroup("onButton3")
    elseif inputEnum == input.BUTTON_4 then
        pollControllableGroup("onButton4")
    end
end



function listener:mousepressed(button, x, y)
    if state.getCurrentState() ~= "game" then
        return
    end

    -- TODO: This aint working!!! Maybe it's mousedown??? idk 
    if button == 1 then
        pollControllableGroup("onClick", x, y)
    end

    listener:lockMouseButtons()
end





local DEFAULT_SPEED = 200

local SPEED_AGILITY_SCALE = 12


local max, min = math.max, math.min


local function updateEnt(ent, dt)
    local speed = ent.speed or DEFAULT_SPEED
    local agility = ent.agility or (speed * SPEED_AGILITY_SCALE)
    local delta = agility * dt

    if listener:isControlDown(input.UP) then
        ent.vy = max(-speed, ent.vy - delta)
    end
    if listener:isControlDown(input.DOWN) then
        ent.vy = min(speed, ent.vy + delta)
    end
    if listener:isControlDown(input.LEFT) then
        ent.vx = max(-speed, ent.vx - delta)
    end
    if listener:isControlDown(input.RIGHT) then
        ent.vx = min(speed, ent.vx + delta)
    end
end




local function followAverage(sum_x, sum_y, len)
    --[[
        follows the camera based on average positions
    ]]
    local avg_x, avg_y = 0, 0
    if len > 0 then
        avg_x = sum_x / len
        avg_y = sum_y / len
    end
    base.client.camera:follow(avg_x, avg_y)
end



local function shouldFollow()
    local blocked = umg.ask("isCameraPlayerFollowBlocked", operators.OR)
    return not blocked
end


function listener:update(dt)
    local sum_x = 0
    local sum_y = 0
    local len = 0
    local has_follow = false
    
    for _, ent in ipairs(controllableGroup) do
        if ent.controller == client.getUsername() and ent.x and ent.vx then
            updateEnt(ent, dt)
            if ent.follow then
                has_follow = true
                sum_x = sum_x + ent.x
                sum_y = sum_y + ent.y - (ent.z or 0) / 2
                len = len + 1
            end
        end
    end

    if has_follow and shouldFollow() then
        followAverage(sum_x, sum_y, len)
    end
end



--[[
    When we recieve a `tick` from the server,
    send the server our player's position.
    (Note that the server can choose to deny our player position 
      if it thinks we are cheating!!!)
]]
umg.on("@tick", function(dt)
    if state.getCurrentState() ~= "game" then
        return
    end

    for i, ent in ipairs(controllableGroup) do
        if ent.controller == client.getUsername() then
            client.send("setPlayerPosition", ent, ent.x, ent.y, ent.z)
            if ent.vx and ent.vy then
                client.send("setPlayerVelocity", ent, ent.vx, ent.vy, ent.vz)
            end
        end
    end
end)



client.on("forceSetPlayerPosition", function(player, x, y, z)
    player.x = x
    player.y = y
    player.z = z
end)








return control
