


local commandToCallback = {}

server.on("commandMessage", function(sender_uname, commandName, ...)
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
            ar[i](sender_uname, ...)
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

