

--[[

`gameState` is the state that represents the regular game.

When the game is running, it should be in this state.


]]

local State = require("shared.state.state")

local gameState = State("game")


local constants = require("shared.constants")
local operators = require("shared.operators")


local MULT = operators.MULT
local MAX_DT = constants.MAX_DT
local MIN_DT = constants.MIN_DT
local max, min = math.max, math.min



gameState:on("@update", function(dt)
    local modif = umg.ask("getDeltaTimeModifier", MULT) or 1
    dt = min(MAX_DT, max(MIN_DT, dt * modif))

    umg.call("gamePreUpdate", dt)
    umg.call("gameUpdate", dt)
    umg.call("gamePostUpdate", dt)
end)

gameState:on("@draw", function(dt)
    umg.call("drawWorld")
    umg.call("drawUI")
end)



-- and set to gamestate if we are on serverside
if server then
    State.setState("game")
end

