
--[[

Handles player control


]]
require("control_events")


local control = {}


local controllableGroup = umg.group("controllable")




local listener = input.Listener({priority = -1})



--[[

Do some more thinking about this commented-out api.

I don't *think* it's a good idea to keep it...
but lowkey, this API was onto something.

I'm going to keep it around, since it was a decent idea.


local function callInput(lis, inputEnum)
    for _, ent in ipairs(controllableGroup) do
        if sync.isClientControlling(ent) then
            umg.call("control:entityAction", ent, inputEnum, lis)
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
]]





local DELTA = 1000
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
