
--[[

Maps local server events automatically to the client.

]]

local definedEvents = {}

local function defineEventProxy(eventName)
    if type(eventName) ~= "string" then
        error("Expected string as first argument")
    end
    if definedEvents[eventName] then
        error("This event is already defined: " .. eventName)
    end

    local networkEventName = "proxy_" .. eventName
    if server then
        umg.on(eventName, function(...)
            server.broadcast(networkEventName, ...)
        end)
    elseif client then
        client.on(networkEventName, function(...)
            umg.call(eventName, ...) 
        end)
    end
end


return defineEventProxy

