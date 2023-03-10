


local commandToHandler = {}




local DEFAULT_ADMIN_LEVEL = 0


local ADMIN_LEVELS = {}

ADMIN_LEVELS[server.getHostUsername()] = math.huge





local chat = {}


function chat.getAdminLevel(username)
    return ADMIN_LEVELS[username] or DEFAULT_ADMIN_LEVEL
end

local setAdminLevelAssert = base.typecheck.assert("string", "number")
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



local VALID_TYPES = {
    string = true,
    number = true,
    entity = true,
    boolean = true
}

local function getArgsTypechecker(arguments)
    local typeBuffer = base.Array()
    for _, arg in ipairs(arguments) do
        assert(VALID_TYPES[arg.type], "arg type invalid: " .. tostring(arg.type))
        assert(type(arg.name) == "string", "arg.name needs to be string")
        typeBuffer:add(arg.type)
    end
    return base.typecheck.check(unpack(typeBuffer))
end



local handleCommandTypecheck = base.typecheck.assert("string", "table")


function chat.handleCommand(commandName, handler)
    --[[
        {
            handler = function(sender, etype, x, y)
                if not server.entities[etype] then
                return nil, "couldn't find entity"
                end

                server.entities[etype](x,y)
                return true
            end,

            adminLevel = 5, -- minimum level required to execute this command

            args = {
                {type = "string", name = "etype"},
                {type = "number", name = "x"},
                {type = "number", name = "y"}
            }
        }
    ]]
    handleCommandTypecheck(commandName, handler)
    assert(type(handler.handler) == "function", "not given .handler function")
    assert(type(handler.arguments) == "table", "not given .arguments table")
    assert(handler.adminLevel, "not given .adminLevel number")
    handler.typechecker = getArgsTypechecker(handler.arguments)
    commandToHandler[commandName] = handler
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
    local handler = commandToHandler[commandName]
    if not handler then
        chat.privateMessage(sender_uname, "unknown command: " .. commandName)
        return
    end

    local ok, err = handler.typechecker(...)
    if not ok then
        chat.privateMessage(sender_uname, "/" .. commandName .. ": " .. err)
        return
    end

    local adminLevel = chat.getAdminLevel(sender_uname)
    if handler.adminLevel > adminLevel then 
        chat.privateMessage(sender_uname, "/" .. commandName .. ": Admin level " .. tostring(handler.adminLevel) .. " required.")
        return
    end

    handler.handler(sender_uname, ...)
end)






chat.handleCommand("promote", {
    arguments = {
        {name = "user", type = "string"}, {name = "level", type = "number"}
    },

    adminLevel = 1,

    handler = function(sender, user, level)
        local adminLv = chat.getAdminLevel(sender)
        local targetAdminLv = chat.getAdminLevel(user)
        level = math.max(targetAdminLv, level)
        if adminLv > level and adminLv > targetAdminLv then
            chat.setAdminLevel(user, level)
        end
    end
})




chat.handleCommand("demote", {
    arguments = {
        {name = "user", type = "string"}, {name = "level", type = "number"}
    },

    adminLevel = 1,

    handler = function(sender, user, level)
        local adminLv = chat.getAdminLevel(sender)
        local targetAdminLv = chat.getAdminLevel(user)
        level = math.min(targetAdminLv, level)
        if adminLv > level and adminLv > targetAdminLv then
            chat.setAdminLevel(user, level)
        end
    end
})



umg.expose("chat", chat)

