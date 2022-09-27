
--[[

abstracting away the input.

TODO: Allow for even more custom stuff, like joysticks

]]

local DEFAULT_INPUT_MAPPING =  {
    UP = "w",
    LEFT = "a",
    DOWN = "s",
    RIGHT = "d",

    BUTTON_SPACE = "space",

    BUTTON_LEFT = "q",
    BUTTON_RIGHT = "e",

    BUTTON_1 = "r",
    BUTTON_2 = "f",
    BUTTON_3 = "c",
    BUTTON_4 = "x"
}



local validInputEnums = {}


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

local isDownMapping = {}
-- { [inputEnum] -> true/false (whether input is down or not) }

local inputEnums = {}
-- { [inputEnum] -> inputEnum } used by input table.
-- i.e.  base.input.BUTTON_1

local inputList = {}



local input = setmetatable({}, {
    __index = function(t,k)
        if inputEnums[k] then
            return inputEnums[k]
        else
            error("Accessed an undefined key in input table: " .. tostring(k))
        end
    end
})



local function updateTables(inpMapping)
    inputMapping = inpMapping
    scancodeMapping = invert(inpMapping)
    isDownMapping = {}
    validInputEnums = {}
    inputEnums = {}
    inputList = {}

    for inpEnum, _ in ipairs(inpMapping)do
        isDownMapping[inpEnum] = false
        validInputEnums[inpEnum] = true
        inputEnums[inpEnum] = inpEnum
        table.insert(inputList, inpEnum)
    end
end



function input.isDown(inputEnum)
    inputEnum = inputEnum or "nil" -- to ensure we dont get `table index nil`
    if not validInputEnums(inputEnum) then
        error("invalid input enum: " .. inputEnum, 2)
    end

    return isDownMapping[inputEnum]
end



local function assertValid(inpMapping)
    for inputEnum, scancode in pairs(inpMapping) do
        if not validInputEnums(inputEnum) then
            error("invalid input enum: " .. inputEnum, 2)
        end
        keyboard.getKeyFromScancode(scancode) -- this just assets that the scancode is valid.
    end
end





function input.setControls(inpMapping)
    assertValid(inpMapping)
    updateTables(inpMapping)
end


input.setControls(DEFAULT_INPUT_MAPPING)









local locked = false


function input.lock()
    locked = true
end

function input.unlock()
    locked = false
end

function input.isLocked()
    return locked
end








on("keypressed", function(_, scancode, isrepeat)
    if (not locked) and scancodeMapping[scancode] then
        local inputEnum = scancodeMapping[scancode]
        call("inputPressed", inputEnum, isrepeat)
        isDownMapping[inputEnum] = true
    end
end)


on("keyreleased", function(_, scancode, isrepeat)
    if (not locked) and scancodeMapping[scancode] then
        local inputEnum = scancodeMapping[scancode]
        call("inputReleased", inputEnum, isrepeat)
        isDownMapping[inputEnum] = false
    end
end)



return input
