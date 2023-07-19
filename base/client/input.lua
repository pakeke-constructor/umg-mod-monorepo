
--[[

abstracting away the input.

TODO: Allow for even more custom stuff, like joysticks

]]



-- The input mapping can be defined as anything,
-- but the base mod uses these controls by default:::
local DEFAULT_INPUT_MAPPING =  {
    UP = "w", -- (If you do change the controls, note that you can change the key it points to,
    LEFT = "a", -- but make sure to always keep the UP, DOWN, RIGHT, BUTTON_1, etc.)
    DOWN = "s",
    RIGHT = "d",

    BUTTON_SPACE = "space",
    BUTTON_SHIFT = "lshift",
    BUTTON_CONTROL = "lctrl",

    BUTTON_LEFT = "q",
    BUTTON_RIGHT = "e",

    BUTTON_1 = "r",
    BUTTON_2 = "f",
    BUTTON_3 = "c",
    BUTTON_4 = "x"
}



local validInputEnums = {}

for enum,_ in pairs(DEFAULT_INPUT_MAPPING) do
    validInputEnums[enum] = true
end


local function invert(mapping)
    local inverted = {}
    for k,v in pairs(mapping) do
        assert(not inverted[v], "Duplicate entry in control mapping: " .. tostring(v))
        inverted[v] = k
    end
    return inverted
end




local inputMapping = DEFAULT_INPUT_MAPPING 
-- { [inputEnum] -> scancode }
local scancodeMapping = invert(inputMapping)
-- { [scancode] -> inputEnum }
local inputEnums = {}
-- { [inputEnum] -> inputEnum } used by input table.
-- i.e.  input.BUTTON_1



local lockedScancodes = {--[[
    keeps track of the scancodes that are currently locked by a listener
    [scancode] --> listener
]]}

local lockedMouseButtons = {--[[
    keeps track of what mouse buttons are locked by what listener
    [mouseButton] -> listener
]]}




local sortedListeners = {}


local keyboardIsLocked = false


local mouseButtonsAreLocked = false
local mouseWheelIsLocked = false
local mouseMovementIsLocked = false




local input = setmetatable({}, {
    __index = function(t,k)
        if inputEnums[k] then
            return inputEnums[k]
        else
            error("Accessed an undefined key in input table: " .. tostring(k))
        end
    end
})



local lockChecks = {}
function lockChecks.keypressed(key, scancode, isrepeat)
    return keyboardIsLocked or lockedScancodes[scancode]
end
function lockChecks.keyreleased()
    return keyboardIsLocked
end
function lockChecks.mousepressed(x, y, button, istouch, presses)
    return mouseButtonsAreLocked or lockedMouseButtons[button]
end
function lockChecks.textinput(txt)
    return keyboardIsLocked or lockedScancodes[txt]
end
function lockChecks.wheelmoved()
    return mouseWheelIsLocked
end
function lockChecks.mousereleased()
    return mouseButtonsAreLocked
end
function lockChecks.mousemoved()
    return mouseMovementIsLocked
end






local Listener = objects.Class("base:Listener")
input.Listener = Listener

local DEFAULT_LISTENER_PRIORITY = 0



local function sortPrioKey(obj1, obj2)
    -- sorts backwards; i.e. higher priority
    -- comes first in the list 
    
    -- default priority is 0
    return (obj1.priority or 0) > (obj2.priority or 0)
end



function Listener:init(options)
    for k,v in pairs(options)do
        self[k] = v
    end
    
    self.priority = self.priority or DEFAULT_LISTENER_PRIORITY
    table.insert(sortedListeners, self)
    table.sort(sortedListeners, sortPrioKey)
end


function Listener:lockKey(scancode)
    if lockedScancodes[scancode] and lockedScancodes[scancode] ~= self then
        error("scancode was already locked")
    end
    lockedScancodes[scancode] = self
end


function Listener:lockMouseButton(mousebutton)
    if lockedMouseButtons[mousebutton] and lockedMouseButtons[mousebutton] ~= self then
        error("mouse button was already locked")
    end
    lockedMouseButtons[mousebutton] = self
end



function Listener:getKey(inputEnum)
    return inputMapping[inputEnum]
end

function Listener:getInputEnum(scancode)
    return scancodeMapping[scancode]
end


function Listener:isKeyLocked(scancode)
    return lockedScancodes[scancode] and (lockedScancodes[scancode] ~= self)
end

function Listener:isMouseButtonLocked(mousebutton)
    return lockedMouseButtons[mousebutton] and lockedMouseButtons[mousebutton] ~= self
end


local function isValidInputEnum(value)
    return value and inputMapping[value]  
end


function Listener:isControlDown(inputEnum)
    assert(isValidInputEnum(inputEnum), "Invalid input enum: " .. inputEnum)
    local scancode = self:getKey(inputEnum)
    return self:isKeyDown(scancode)
end

function Listener:isKeyDown(scancode)
    if self:isKeyLocked(scancode) then
        return false
    end
    if keyboardIsLocked then
        return false
    end
    return love.keyboard.isScancodeDown(scancode)
end

function Listener:isMouseButtonDown(mousebutton)
    if mouseButtonsAreLocked then
        return false
    end
    if self:isMouseButtonLocked(mousebutton) then
        return false
    end
    return love.mouse.isDown(mousebutton)
end


--[[
    blocks keyboard events for the rest of the frame
]]
function Listener:lockKeyboard()
    keyboardIsLocked = true
end

--[[
    blocks mouse button events for the rest of the frame
]]
function Listener:lockMouseButtons()
    mouseButtonsAreLocked = true
end

--[[
    blocks mouse wheel events for the rest of the frame
]]
function Listener:lockMouseWheel()
    mouseWheelIsLocked = true
end

--[[
    blocks mouse movement events for the rest of the frame
]]
function Listener:lockMouseMovement()
    mouseMovementIsLocked = true
end


--[[
    blocks all mouse events for the rest of the frame
]]
function Listener:lockMouse()
    self:lockMouseButtons()
    self:lockMouseWheel()
    self:lockMouseMovement()
end









local inputList

local function updateTables(inpMapping)
    inputMapping = inpMapping
    scancodeMapping = invert(inpMapping)
    inputEnums = {}
    inputList = {}

    for inpEnum, _ in pairs(inpMapping)do
        inputEnums[inpEnum] = inpEnum
        table.insert(inputList, inpEnum)
    end
end



local function assertValid(inpMapping)
    for inputEnum, scancode in pairs(inpMapping) do
        if not validInputEnums[inputEnum] then
            error("invalid input enum: " .. inputEnum, 2)
        end
        love.keyboard.getKeyFromScancode(scancode) -- this just assets that the scancode is valid.
    end
end



function input.unlockEverything()
    keyboardIsLocked = false
    mouseButtonsAreLocked = false
    mouseWheelIsLocked = false
    mouseMovementIsLocked = false
end



function input.setControls(inpMapping)
    assertValid(inpMapping)
    updateTables(inpMapping)
end


input.setControls(DEFAULT_INPUT_MAPPING)








local eventBuffer = objects.Array()







local function pollEvents(listener)
    for _, event in ipairs(eventBuffer) do
        if listener[event.type] then
            local isLocked = lockChecks[event.type](unpack(event.args))
            if (not isLocked) then
                local func = listener[event.type]
                assert(type(func) == "function", "listeners must be functions")
                func(listener, unpack(event.args))
                -- ensure to pass self as first arg 
            end
        end
    end
end



umg.on("@update", function(dt)
    if not client.isPaused() then
        for _, listener in ipairs(sortedListeners) do
            pollEvents(listener)
            
            if listener.update then
                listener:update(dt)
            end
        end
    end

    eventBuffer:clear()
    input.unlockEverything()
end)




umg.on("@keypressed", function(key, scancode, isrepeat)
    eventBuffer:add({
        args = {key, scancode, isrepeat},
        type = "keypressed"
    })
end)


umg.on("@keyreleased", function(key, scancode)
    eventBuffer:add({
        args = {key, scancode},
        type = "keyreleased"
    })
    lockedScancodes[scancode] = nil
end)


umg.on("@wheelmoved", function(dx, dy)
    eventBuffer:add({
        args = {dx, dy},
        type = "wheelmoved"
    })
end)

umg.on("@mousemoved", function (x, y, dx, dy, istouch)
    eventBuffer:add({
        args = {x, y, dx, dy, istouch},
        type = "mousemoved"
    })
end)

umg.on("@mousepressed", function (x, y, button, istouch, presses)
    eventBuffer:add({
        args = {x, y, button, istouch, presses},
        type = "mousepressed"
    })
end)

umg.on("@mousereleased", function(x, y, button, istouch, presses)
    eventBuffer:add({
        args = {x, y, button, istouch, presses},
        type = "mousereleased"
    })
    lockedMouseButtons[button] = false
end)

umg.on("@textinput", function(txt)
    eventBuffer:add({
        args = {txt},
        type = "textinput"
    })
end)



return input

