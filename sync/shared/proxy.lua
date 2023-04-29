
--[[

Maps local server events automatically to the client.

For example, if umg.call("hello", 1, 2) is called on the server,
then umg.call("hello", 1, 3) will be called automatically on the client.


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

