
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
-- i.e.  base.input.BUTTON_1




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




function input.isDown(inputEnum)
    if locked then
        return false
    end
    inputEnum = inputEnum or "nil" -- to ensure we dont get `table index nil`
    if not validInputEnums[inputEnum] then
        error("invalid input enum: " .. inputEnum, 2)
    end

    local scancode = inputMapping[inputEnum]
    return love.keyboard.isScancodeDown(scancode)
end








umg.on("gameKeypressed", function(_, scancode, isrepeat)
    if (not locked) and scancodeMapping[scancode] then
        local inputEnum = scancodeMapping[scancode]
        umg.call("inputPressed", inputEnum, isrepeat)
    end
end)


umg.on("gameKeyreleased", function(_, scancode, isrepeat)
    if (not locked) and scancodeMapping[scancode] then
        local inputEnum = scancodeMapping[scancode]
        umg.call("inputReleased", inputEnum, isrepeat)
    end
end)




return input

