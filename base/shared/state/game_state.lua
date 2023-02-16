
local state = require("shared.state.state")

--[[

`gameState` is the state that represents the regular game.

When the game is running, it should be in this state.


]]
local gameState = {
    name = "game"
}




function gameState.update(dt)
    umg.call("gameUpdate", dt)
end
function gameState.draw()
    umg.call("gameDraw")
end
function gameState.keypressed(key,sc,isrepeat)
    umg.call("gameKeypressed", key,sc,isrepeat)
end
function gameState.keyreleased(key,sc,isrepeat)
    umg.call("gameKeyreleased", key,sc,isrepeat)
end
function gameState.textedited(...)
    umg.call("gameTextedited", ...)
end
function gameState.focus(...)
    umg.call("gameFocus", ...)
end
function gameState.resize(...)
    umg.call("gameResize", ...)
end
function gameState.mousemoved(...)
    umg.call("gameMousemoved", ...)
end
function gameState.mousepressed(...)
    umg.call("gameMousepressed", ...)
end
function gameState.mousereleased(...)
    umg.call("gameMousereleased", ...)
end
function gameState.wheelmoved(...)
    umg.call("gameWheelmoved", ...)
end


for cbName, cbFunc in pairs(gameState) do
    gameState["@" .. cbName] = cbFunc
end




-- define gamestate
state.defineState(gameState)


-- and set to gamestate if we are on serverside
if server then
    state.setState("game")
end


