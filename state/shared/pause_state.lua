

--[[

`pauseState` is when the game is paused.


]]


local state = require("shared.state")

local pauseState = state.State("pause")



pauseState:on("@draw", function(dt)
    umg.call("state:drawWorld")
    umg.call("state:drawUI")
end)

