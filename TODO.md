

## TODO:
State machine for game update state


### PLANNING:

base.state module

Two states exist by default:
`pause` state, and `game` state.

```lua

base.state.getState() -- returns the current state of the game

base.state.setState(X) -- sets the state, and syncs across all clients.
-- This function can only be called by the server.

base.state.isValidState(X) -- returns true/false,
-- whether X is a valid state name or not




--[[

This will allow us to change up how we use the `input` module a bit too.

Instead of needing `input.lock()` for everything, can instead simply
use `gameKeypressed` in the input handler!


]]


base.state.defineState({
    name = "game",

    enter = function()
        call("enterGameState")
    end,
    exit = function()
        call("exitGameState")
    end,
    
    update = function(dt)
        call("gameUpdate", dt)
    end,
    draw = function()
        call("gameDraw")
    end,

    keypressed = function(...)
        call("gameKeypressed", ...)
    end,
    keyreleased = function(...)
        call("gameKeyreleased", ...)
    end,
    textedited = function(...)
        call("gameTextedited", ...)
    end,

    focus = function(...)
        call("gameFocus", ...)
    end,
    resize = function(...)
        call("gameResize", ...)
    end,

    mousemoved = function(...)
        call("gameMousemoved", ...)
    end,
    mousepressed = function(...)
        call("gameMousepressed", ...)
    end,
    mousereleased = function(...)
        call("gameMousereleased", ...)
    end,
    wheelmoved = function(...)
        call("gameWheelmoved", ...)
    end
})




```

