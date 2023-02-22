
local State = require("shared.state.state")

--[[

`gameState` is the state that represents the regular game.

When the game is running, it should be in this state.


]]

local input
if client then
    input = require("client.input")
end



local gameState = State("game")




gameState:on("@update", function(dt)
    if client then
        -- poll input first, to ensure controls are responsive
        input.update(dt)
    end

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

