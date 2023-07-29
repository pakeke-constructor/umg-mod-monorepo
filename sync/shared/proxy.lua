
--[[

Maps local server events automatically to the client.

For example, if umg.call("hello", 1, 2) is called on the server,
then umg.call("hello", 1, 3) will be called automatically on the client.


]]

local proxiedEvents = {}


local function getFullName(eventName)
    local info = umg.getEventInfo(eventName)
    return info and info.eventName
end



local function proxyEventToClient(eventName)
    if type(eventName) ~= "string" then
        error("Expected string as first argument")
    end
    local evname = getFullName(eventName)
    if proxiedEvents[evname] then
        error("This event is already being proxied: " .. eventName)
    end

    local networkEventName = "proxy_" .. evname
    if server then
        umg.on(evname, function(...)
            server.broadcast(networkEventName, ...)
        end)
    elseif client then
        client.on(networkEventName, function(...)
            umg.call(evname, ...) 
        end)
    end
end


return proxyEventToClient
