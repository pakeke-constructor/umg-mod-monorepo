

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



