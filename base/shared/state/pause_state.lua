

local state = require("shared.state.state")

--[[

`pauseState` is when the game is paused.


]]
local pauseState = {
    name = "pause"
}



function pauseState.draw(...)
    -- We just call gameDraw here, because draw function doesn't (or SHOULDNT) 
    -- mutate the state of the world.
    umg.call("gameDraw", ...)
end


-- define pauseState
state.defineState(pauseState)



