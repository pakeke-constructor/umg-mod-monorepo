

--[[

base state module.

Used for representing when the game is paused,
or when the game is in an alternative state, 
(i.e. worldeditor mode or something)



]]


local state = {}



local stateTable = {}

local currentState = nil



function state.getState()
    return currentState
end


local function changeState(newState)
    if newState ~= currentState then
        if currentState and stateTable[currentState].exit then
            stateTable[currentState].exit()
        end
        if stateTable[newState].enter then
            stateTable[newState].enter()
        end
    end
    currentState = newState
end




if server then

function state.setState(newState)
    if (not newState) or (not stateTable[newState]) then
        error("Invalid state: " .. tostring(newState))
    end
    server.broadcast("baseModSetState", newState)
    changeState(newState)
end

on("playerJoin", function(username)
    server.unicast(username, "baseModSetState", currentState)
end)


else -- we on client side

client.on("baseModSetState", function(newState)
    changeState(newState)
end)

end


local CALLBACKS = {
    "update", "draw",
    "keypressed", "keyreleased",
    "textedited",
    "focus", "resize",
    "mousemoved", "mousepressed", "mousereleased", "wheelmoved"
}


function state.defineState(stateObj)
    local name = stateObj.name
    assert(type(name) == "string", "state definitions require a .name string")

    for _, cb in ipairs(CALLBACKS) do
        if stateObj[cb] then
            assert(type(stateObj[cb]) == "function", "state callbacks must be functions")
        end
    end
    stateTable[name] = stateObj
end



for _, cb in ipairs(CALLBACKS) do
    -- This kind of reflective, meta programming is kind of hacky..
    -- I'm not a fan of it, but oh well! :-)
    on(cb, function(...)
        if currentState and currentState[cb] then
            currentState[cb](...)
        end
    end)
end





return state
