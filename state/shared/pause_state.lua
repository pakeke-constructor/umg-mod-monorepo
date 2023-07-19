

--[[

`pauseState` is when the game is paused.


]]


local State = require("shared.state.state")

local pauseState = State("pause")



pauseState:on("@draw", function(dt)
    umg.call("drawWorld")
    umg.call("drawUI")
end)

