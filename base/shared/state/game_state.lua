
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



function gameState.keypressed(key,sc,isrepeat)
    input.keypressed(key,sc,isrepeat)
end
function gameState.keyreleased(key,sc,isrepeat)
    input.keyreleased(key,sc,isrepeat)
end
function gameState.textedited(txt)
    input.textedited(txt)
end
function gameState.focus(...)
    umg.call("gameFocus", ...)
end
function gameState.resize(...)
    umg.call("gameResize", ...)
end
function gameState.mousemoved(x, y, dx, dy, istouch)
    input.mousemoved(x, y, dx, dy, istouch)
end
function gameState.mousepressed(...)
    umg.call("gameMousepressed", ...)
end
function gameState.mousereleased(button,x,y,isrepeat)
    umg.call("gameMousereleased", button,x,y,isrepeat)
end
function gameState.wheelmoved(dx,dy)
    input.wheelmoved(dx,dy)
end



-- and set to gamestate if we are on serverside
if server then
    State.setState("game")
end


