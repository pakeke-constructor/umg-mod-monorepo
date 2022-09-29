

--[[

base state module.

Used for representing when the game is paused,
or when the game is in an alternative state, 
(i.e. worldeditor mode or something)



]]


local state = {}



local stateTable = {}

local currentStateName = nil



function state.getState()
    return currentStateName
end


local function changeState(name)
    assert(name)
    if name ~= currentStateName then
        if currentStateName and stateTable[currentStateName].exit then
            stateTable[currentStateName].exit()
        end
        if stateTable[name].enter then
            stateTable[name].enter()
        end
    end
    currentStateName = name
end




if server then

function state.setState(name)
    if (not name) or (not stateTable[name]) then
        error("Invalid state: " .. tostring(name))
    end
    server.broadcast("baseModSetState", name)
    changeState(name)
end

on("playerJoin", function(username)
    server.unicast(username, "baseModSetState", currentStateName)
end)


else -- we on client side

client.on("baseModSetState", function(name)
    changeState(name)
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
        local stateObj = stateTable[currentStateName]
        if stateObj and stateObj[cb] then
            stateObj[cb](...)
        end
    end)
end





return state
