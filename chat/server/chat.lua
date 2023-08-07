

--[[
    serverside chat api
]]
local chat = {}






--[[

TODO: Rate limit the number of messages that can be sent
per user, to prevent spamming.

]]

local constants = require("constants")



-- start of command character in minecraft, like `/` in minecraft.
local commandCharString = "/!;?$"
local commandChars = {}

for i=1, #commandCharString do
    commandChars[commandCharString:sub(i,i)] = true
end


local sf = sync.filters

server.on("chatMessage", {
    arguments = {sf.string, sf.string},
    handler = function(sender, message, channel)
        if type(message)~="string"then
            return
        end
        if #message > constants.MAX_MESSAGE_SIZE then
            return
        end
        if commandChars[message:sub(1,1)] then
            return  -- nope!
        end
        if not channel then
            -- TODO: Do colored names here
            local msg = "[" .. sender .. "]" .. " " .. message
            server.broadcast("chatMessage", msg)
        else
            print("TODO: Do chat message channels")
        end
    end
})











local DEFAULT_ADMIN_LEVEL = 0


local ADMIN_LEVELS = {}

ADMIN_LEVELS[server.getHostUsername()] = math.huge


function chat.getAdminLevel(username)
    return ADMIN_LEVELS[username] or DEFAULT_ADMIN_LEVEL
end

local setAdminLevelAssert = typecheck.assert("string", "number")
function chat.setAdminLevel(username, level)
    setAdminLevelAssert(username, level)
    ADMIN_LEVELS[username] = level
end



function chat.message(message)
    server.broadcast("chatMessage", message)
end


function chat.privateMessage(username, message)
    server.unicast( username, "chatMessage", message)
end


return chat

