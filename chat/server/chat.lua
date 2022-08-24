

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



server.on("chatMessage", function(sender, message, channel)
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
        local msg = "[" .. sender .. "]" .. " " .. message
        server.broadcast("chatMessage", msg)
    end
end)



local commandToCallback = {}

server.on("commandMessage", function(sender, commandName, ...)
    --[[
        this is for when the player does any of the following:
        /commandName ...
        !commandName ...
        ;commandName ...
        ?commandName ...
        $commandName ...
    ]]
    if commandToCallback[commandName] then
        local ar = commandToCallback[commandName]
        for i=1, #ar do
            ar[i](...)
        end
    end
end)


local chat = {}


function chat.handleCommand(commandName, func)
    local ar = commandToCallback[commandName] or {}
    if #ar > 500 then
        error("Too many command handles have been defined. Command handles should only be defined once.")
    end
    if type(func) ~="function" then
        error("chat.handleCommand(cmdName, func) expects a function as second argument. Instead, got: " .. type(func))
    end
    table.insert(ar, func)
    commandToCallback[commandName] = ar
end

export("chat", chat)

