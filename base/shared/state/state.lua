

--[[

base state module.

Used for representing when the game is paused,
or when the game is in an alternative state, 
(i.e. worldeditor mode or something)



]]

local Class = require("shared.class")
local typecheck = require("shared.typecheck")


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

umg.on("playerJoin", function(username)
    server.unicast(username, "baseModSetState", currentStateName)
end)


else -- we on client side

client.on("baseModSetState", function(name)
    changeState(name)
end)

end


local LISTENING_CALLBACKS = {--[[
    [eventName] --> true    
    keeps track of what events are being listened to by the state handler
]]}





local function isListening(event_name)
    return LISTENING_CALLBACKS[event_name]
end



local function tryDefineNewListener(event_name)
    -- This kind of reflective, meta programming is kind of hacky..
    -- I'm not a fan of it, but oh well! :-)
    if isListening(event_name) then
        return
    end
    LISTENING_CALLBACKS[event_name] = true
    umg.on(event_name, function(...)
        local stateObj = stateTable[currentStateName]
        if stateObj and stateObj[event_name] then
            stateObj[event_name](...)
        end
    end)
end




local State = Class("base:State")



local assertStringArg = typecheck("string")
function State:init(name)
    assertStringArg(name)
    stateTable[name] = self
    self.name = name
    self.eventListeners = {
        -- [ev_name] --> function() end
    }
    state.defineState(self)
end



local onAsserter = typecheck("string", "function")

function State:on(event_name, func)
    onAsserter(event_name, func)
    assert(not self.eventListeners[event_name], "Not allowed to override")
    
    self.eventListeners[event_name] = func
    tryDefineNewListener(event_name)
end





function State.getCurrentState()
    return currentStateName
end




--[[
    this function should be called from a static context
    i.e.
    State.setState("game")
]]
function State.setState(name_or_nil)
    assertStringArg(name_or_nil)    
end




return State
