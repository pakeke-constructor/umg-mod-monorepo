
local ENUM_MT = {__index=function(_,k) error("undefined enum: " .. k) end}


local constants = {

    --[[
        TODO: Do some more planning about thos.
    ]]
    USE_TYPE = setmetatable({
        
        CONTINUOUS = "CONTINUOUS", -- i.e. hold mouse to draw
        DISCRETE = "DISCRETE" -- i.e. press mouse once to draw

    }, ENUM_MT)

}

return constants

