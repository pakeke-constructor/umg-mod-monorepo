
--[[

abstracting away the input.

TODO: Allow for even more custom stuff, like joysticks

]]

local Array = require("shared.array")



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
-- i.e.  base.input.BUTTON_1


local scancodeToIsDown = {}
-- { [scancode]  ->  true/false }  whether scancode is down or not
local scancodeToLockingListener = {}
-- { [scancode]  ->  Listener  }  the Listener that is currently locking this scancode (if any)


local scancodeToWhenListeners = {--[[
    [scancode] -> sorted WhenListener list
]]}
local scancodeToActionListeners = {--[[
    [scancode] -> sorted ActionListener list
]]}
local globalActionListeners = {}




local mouseButtonToActionListener = {--[[
    [mouseButton] -> sorted ActionListenerList
]]}




local keyboardIsLocked = false

local mouseIsLocked = false

local mouseWheelIsLocked = false




local input = setmetatable({}, {
    __index = function(t,k)
        if inputEnums[k] then
            return inputEnums[k]
        else
            error("Accessed an undefined key in input table: " .. tostring(k))
        end
    end
})


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
    mouseIsLocked = false
    mouseWheelIsLocked = false
end

function input.lockKeyboard()
    keyboardIsLocked = true
end

function input.lockMouseButtons()
    mouseIsLocked = true
end

function input.lockMouseWheel()
    mouseWheelIsLocked = true
end

function input.lockMouse()
    input.lockMouseButtons()
    input.lockMouseWheel()
end




function input.setControls(inpMapping)
    assertValid(inpMapping)
    updateTables(inpMapping)
end


input.setControls(DEFAULT_INPUT_MAPPING)




local function sortPrioKey(obj1, obj2)
    -- sorts backwards; i.e. higher priority
    -- comes first in the list 
    
    -- default priority is 0
    return (obj1.priority or 0) > (obj2.priority or 0)
end




local function isValidInputValue(value)
    return value and inputMapping[value]  
end




function input.whenInputDown(listener)
    --[[
        An when listener is just a lua table:

        listener = {
            input = input.UP,
            priority = 10, -- higher priority = called first
            update = function(scancode, dt)
                ... -- do something
                input.lockKey(scancode)
            end
        }
    ]]
    assert(isValidInputValue(listener.input) or listener.scancode, "need valid input")
    assert(type(listener.update) == "function", "need update function")
    
    local scancode = listener.scancode or scancodeMapping[listener.input]
    scancodeToWhenListeners[scancode] = scancodeToWhenListeners[scancode] or {}

    table.insert(scancodeToWhenListeners[scancode], listener)
    table.sort(scancodeToWhenListeners[scancode], sortPrioKey)
end



function input.onKeyboardAction(listener)
    --[[
        An action listener is just a lua table:

        listener = {
            priority = 5,
            onPress = function(scancode, isrepeat)
                if isTyping then
                    textBuffer = textBuffer .. scancode
                    return true -- lock
                else
                    return false -- no lock
                end
            end,
            onRelease = function(scancode)
            end
        }
    ]]
    assert(isValidInputValue(listener.input) or listener.scancode, "need valid input")
    assert(type(listener.onPress) == "function", "need onPress function")
    assert(type(listener.onRelease) == "function", "need onRelease function")
    
    local scancode = listener.scancode or scancodeMapping[listener.input]
    local arr
    if scancode then
        scancodeToActionListeners[scancode] = scancodeToActionListeners[scancode] or {}
        arr = scancodeToActionListeners[scancode]
    else
        arr = globalActionListeners
    end

    table.insert(arr, listener)
    table.sort(arr, sortPrioKey)
end



local function getScancodeLock(scancode)
    return scancodeToLockingListener[scancode]
end



--[[
    keypress and keyreleased events are buffered here
]]
local keyboardEventBuffer = Array()


--[[
    mouse events are buffered here (buttons and scroll wheel)
]]
local mouseEventBuffer = Array()





local EMPTY = {}


local function pollKeyPressEvent(event)
    local scancode = event.scancode
    local actionListeners = scancodeToActionListeners[scancode] or EMPTY

    -- polling action Listeners
    local global_i = 1
    local loc_i = 1
    local consumed = false
    while not consumed and (globalActionListeners[global_i] or actionListeners[loc_i]) do
        local globalAction = globalActionListeners[global_i]
        local localAction = actionListeners[loc_i]
        local action

        local globalPrio = globalAction and globalAction.priority or -math.huge
        local localPrio = localAction and localAction.priority or -math.huge

        if localPrio >= globalPrio then
            -- take local action listener
            action = localAction
            loc_i = loc_i + 1
        else
            -- take global action listener
            action = globalAction
            global_i = global_i + 1
        end
        consumed = action.onPress(scancode, event.isrepeat)
        if consumed then
            scancodeToLockingListener[scancode] = true
            return
        end
    end

    scancodeToIsDown[scancode] = true
end


local function pollKeyReleaseEvent(event)
    local scancode = event.scancode
    scancodeToLockingListener[scancode] = nil
    scancodeToIsDown[scancode] = false
end




local function pollWhenListeners(scancode, dt)
    if scancodeToLockingListener[scancode] then
        return -- it's already locked
    end
    local arr = scancodeToWhenListeners[scancode]
    -- should be sorted by prio
    for _, whenListener in ipairs(arr) do
        local consumed = whenListener.update(dt, scancode)
        if consumed then
            return
        end
    end
end


local function updateWhenListeners(dt)
    for scancode, isDown in pairs(scancodeToIsDown) do
        if isDown then
            pollWhenListeners(scancode, dt)
        end
    end
end





local function updateKeyboardEvents(dt)
    for _, event in ipairs(keyboardEventBuffer) do
        if keyboardIsLocked then
            return
        end
        if event.type == "keypress" then
            local listener = getScancodeLock(event.scancode)
            if listener then
                -- The scancode is locked by a listener!
                -- Thus, we inform the listener that another keypress has occured
                listener.onPress(event.scancode, event.isrepeat)
            else
                pollKeyPressEvent(event)
            end
        elseif event.type == "keyrelease" then
            pollKeyReleaseEvent(event)
        elseif event.type == "textinput" then
            
        else
            error("unknown event type: " .. tostring(event.type))
        end
    end
end



function input.update(dt)
    -- should be called whenever we want to poll for input
    updateKeyboardEvents(dt)

    for _, mouseEvent in ipairs(mouseEventBuffer) do
        if event.type == "mousepressed" then

        elseif event.type == "mousereleased" then

        else
            assert(event.type == "wheelmoved", "wat?")

        end
    end

    updateWhenListeners(dt)

    keyboardEventBuffer:clear()
    mouseEventBuffer:clear()

    input.unlockEverything()
end


function input.keypressed(key, scancode, isrepeat)
    keyboardEventBuffer:add({
        key = key,
        scancode = scancode,
        type = "press",
        isrepeat = isrepeat
    })
end


function input.keyreleased(key, scancode)
    keyboardEventBuffer:add({
        key = key,
        scancode = scancode,
        type = "release"
    })
end


function input.wheelmoved(dx, dy)
    mouseEventBuffer:add({
        dx = dx,
        dy = dy,
        type = "wheelmoved"
    })
end

function input.mousepressed(x, y, button, istouch, presses)
    mouseEventBuffer:add({
        x = x,
        y = y,
        button = button,
        istouch = istouch,
        presses = presses,
        type = "mousepressed"
    })
end


function input.mousereleased(x, y, button, istouch, presses)
    mouseEventBuffer:add({
        x = x,
        y = y,
        button = button,
        istouch = istouch,
        presses = presses,
        type = "mousereleased"
    })
end


function input.textinput()

end



return input

