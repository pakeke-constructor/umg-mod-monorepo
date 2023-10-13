

--[[

`gameState` is the state that represents the regular game.

When the game is running, it should be in this state.


]]
require("state_events")
require("state_questions")


local state = require("shared.state")

local gameState = state.State("game")


local MAX_DT = 0.16
local MIN_DT = -0.16



local max, min = math.max, math.min



gameState:on("@update", function(dt)
    local modif = umg.ask("state:getDeltaTimeMultiplier") or 1
    dt = min(MAX_DT, max(MIN_DT, dt * modif))

    umg.call("state:gameUpdate", dt)
end)

gameState:on("@draw", function(dt)
    umg.call("state:drawWorld")
    umg.call("state:drawUI")
end)



-- and set to gamestate if we are on serverside
if server then
    state.setState("game")
end

