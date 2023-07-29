
--[[

Handles player control


]]

local control = {}


local controllableGroup = umg.group("controllable")




local listener = input.Listener({priority = -1})



umg.defineEvent("controllableInput", {
    description = "Called when a player presses an input on a controllable entity, (mousepress or keypress)",
})

local function callInput(lis, inputEnum)
    for _, ent in ipairs(controllableGroup) do
        if sync.isClientControlling(ent) then
            umg.call("controllableInput", ent, inputEnum, lis)
        end
    end
end





function listener:keypressed(key, scancode, isrepeat)
    if state.getCurrentState() ~= "game" then
        return
    end

    local inputEnum = self:getKeyboardInputEnum(scancode)
    callInput(self, inputEnum)
end



function listener:mousepressed(x, y, button)
    if state.getCurrentState() ~= "game" then
        return
    end

    local inputEnum = self:getMouseInputEnum(button)
    assert(inputEnum, "No inputEnum for button" .. button)
    callInput(self, inputEnum)
end






local DELTA = 100
-- this number ^^^ is pretty arbitrary, we just need it to be sufficiently big


local function updateMoveEnt(ent)
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
            if ent.controllable and ent.controllable.movement then
                updateMoveEnt(ent)
            end
        end
    end
end






return control
