
--[[

Handles player control


]]

local control = {}



local controllableGroup = umg.group("controllable", "controller", "x", "y")



local listener = input.Listener({priority = -1})



local function pollControllableGroup(func_key,a,b,c)
    for _, ent in ipairs(controllableGroup) do
        if sync.isClientControlling(ent) then
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






local DELTA = 100
-- this number ^^^ is pretty arbitrary, we just need it to be sufficiently big


local function updateEnt(ent)
    ent.moveX = ent.x
    ent.moveY = ent.y

    if listener:isControlDown(input.UP) then
        ent.moveY = ent.y - DELTA
    end
    if listener:isControlDown(input.DOWN) then
        ent.moveY = ent.y + DELTA
    end
    if listener:isControlDown(input.LEFT) then
        ent.moveX = ent.x - DELTA
    end
    if listener:isControlDown(input.RIGHT) then
        ent.moveX = ent.x + DELTA
    end
end



function listener:update()
    for _, ent in ipairs(controllableGroup) do
        if sync.isClientControlling(ent) and ent.x and ent.y then
            updateEnt(ent)
        end
    end
end





--[[
    TODO: extrapolate this to the `follow` mod
]]

local CAMERA_PRIORITY = 0

local follow_x = 0
local follow_y = 0

local followGroup = umg.group("cameraFollow")


umg.on("@update", function()
    local sum_x = 0
    local sum_y = 0
    local len = 0

    for _, ent in ipairs(followGroup) do
        if ent.x and ent.y then
            sum_x = sum_x + ent.x
            sum_y = sum_y + ent.y - (ent.z or 0) / 2
            len = len + 1
        end
    end

    if len > 0 then
        follow_x = sum_x / len
        follow_y = sum_y / len
    end
end)


umg.answer("getCameraPosition", function()
    return follow_x, follow_y, CAMERA_PRIORITY
end)



return control
