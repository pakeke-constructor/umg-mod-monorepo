

--[[

`pauseState` is when the game is paused.


]]


local state = require("shared.state")

local pauseState = state.State("pause")



pauseState:on("@draw", function(dt)
    umg.call("drawWorld")
    umg.call("drawUI")
end)

