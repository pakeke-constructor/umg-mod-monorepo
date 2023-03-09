


local commandToCallback = {}

local commandToAdminCallback = {}




local ADMINS = base.Set()
ADMINS:add(server.getHostUsername())





local chat = {}


function chat.isAdmin(username)
    return ADMINS:has(username)
end


function chat.message(message)
    server.broadcast("chatMessage", message)
end


function chat.privateMessage(username, message)
    server.unicast( username, "chatMessage", message)
end



local handleCommandTypecheck = base.typecheck.assert("string", "function")

function chat.handleCommand(commandName, func)
    handleCommandTypecheck(commandName, func)
    commandToCallback[commandName] = func
end


function chat.handleAdminCommand(commandName, func)
    handleCommandTypecheck(commandName, func)
    commandToAdminCallback[commandName] = func
end





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
        local func = commandToCallback[commandName]
        func(sender_uname, ...)
        return
    end
    if commandToAdminCallback[commandName] then
        if chat.isAdmin(sender_uname) then
            local func = commandToAdminCallback[commandName]
            func(sender_uname, ...)
        else
            chat.privateMessage(sender_uname, "insufficient permissions to execute: " .. commandName)
        end
        return
    end
    chat.privateMessage(sender_uname, "unknown command: " .. commandName)
end)






chat.handleCommand("promote", function(sender, user)
    if sender == server.getHostUsername() then
        ADMINS:add(user)
    end
end)


chat.handleCommand("demote", function(sender, user)
    if sender == server.getHostUsername() and ADMINS:has(user) then
        ADMINS:remove(user)
    end
end)




umg.expose("chat", chat)

