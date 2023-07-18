

--[[

base state module.

Used for representing when the game is paused,
or when the game is in an alternative state, 
(i.e. worldeditor mode or something)



]]


local State = data.Class("data:State")




local stateTable = {}

local currentStateName = nil




local assertStringArg = typecheck.assert("string")

local function changeState(name)
    assertStringArg(name)
    if name ~= currentStateName then
        if currentStateName and stateTable[currentStateName].exit then
            stateTable[currentStateName]:exit()
        end
        if stateTable[name].enter then
            stateTable[name]:enter()
        end
    end
    currentStateName = name
end




if server then

function State.setState(name)
    if (not name) or (not stateTable[name]) then
        error("Invalid state: " .. tostring(name))
    end
    server.broadcast("baseModSetState", name)
    changeState(name)
end

umg.on("@playerJoin", function(username)
    server.unicast(username, "baseModSetState", currentStateName)
end)


else -- we on client side

client.on("baseModSetState", function(name)
    changeState(name)
end)

end


local LISTENING_CALLBACKS = {--[[
    [eventName] --> true    
    keeps track of what events are already being listened to by the state handler
]]}





local function isListening(event_name)
    return LISTENING_CALLBACKS[event_name]
end



local function ensureListeningTo(event_name)
    -- This kind of reflective, meta programming is kind of hacky..
    -- I'm not a fan of it, but oh well! :-)
    if isListening(event_name) then
        return
    end
    LISTENING_CALLBACKS[event_name] = true
    umg.on(event_name, function(...)
        local stateObj = stateTable[currentStateName]
        if stateObj then
            stateObj:call(event_name, ...)
        end
    end)
end



function State:init(name)
    assertStringArg(name)
    stateTable[name] = self
    self.name = name
    self.eventListeners = {
        -- [ev_name] --> function() end
    }
end



local onAsserter = typecheck.assert("string", "function")

function State:on(event_name, func)
    onAsserter(event_name, func)
    assert(not self.eventListeners[event_name], "Not allowed to override")
    
    self.eventListeners[event_name] = func
    ensureListeningTo(event_name)
end



function State:call(event_name, ...)
    if self.eventListeners[event_name] then
        self.eventListeners[event_name](...)
    end
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
    currentStateName = name_or_nil
end




return State
