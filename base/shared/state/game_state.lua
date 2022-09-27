
local state = require("shared.state.state")

--[[

`gameState` is the state that represents the regular game.

When the game is running, it should be in this state.


]]
local gameState = {
    name = "game"
}




function gameState.update(...)
    call("gameUpdate", ...)
end
function gameState.draw(...)
    call("gameDraw", ...)
end
function gameState.keypressed(...)
    call("gameKeypressed", ...)
end
function gameState.keyreleased(...)
    call("gameKeyreleased", ...)
end
function gameState.textedited(...)
    call("gameTextedited", ...)
end
function gameState.focus(...)
    call("gameFocus", ...)
end
function gameState.resize(...)
    call("gameResize", ...)
end
function gameState.mousemoved(...)
    call("gameMousemoved", ...)
end
function gameState.mousepressed(...)
    call("gameMousepressed", ...)
end
function gameState.mousereleased(...)
    call("gameMousereleased", ...)
end
function gameState.wheelmoved(...)
    call("gameWheelmoved", ...)
end




-- define gamestate
state.defineState(gameState)


