

local commands = {}

--[[

Commands exist on BOTH clientside AND serverside.

If a command is declared on clientside, it will work on clientside only.
If a command is declared on serverside, it will work on serverside only.
If declared on both, it will work on both.


]]



local commandToHandler = {--[[
    [commandName] -> handler_object
]]}





local VALID_TYPES = {
    string = true,
    number = true,
    entity = true,
    boolean = true
}

local function getArgsTypechecker(arguments)
    local typeBuffer = objects.Array()
    for _, arg in ipairs(arguments) do
        assert(VALID_TYPES[arg.type], "arg type invalid: " .. tostring(arg.type))
        assert(type(arg.name) == "string", "arg.name needs to be string")
        typeBuffer:add(arg.type)
    end
    return typecheck.check(unpack(typeBuffer))
end



local handleCommandTypecheck = typecheck.assert("string", "table")


function commands.handleCommand(commandName, handler)
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
            },

            description = "this command does stuff"
        }
    ]]
    handleCommandTypecheck(commandName, handler)
    assert(type(handler.handler) == "function", "not given .handler function")
    assert(type(handler.arguments) == "table", "not given .arguments table")
    assert(handler.adminLevel, "not given .adminLevel number")
    handler.typechecker = getArgsTypechecker(handler.arguments)
    handler.commandName = commandName
    commandToHandler[commandName] = handler
end


local sf = sync.filters


if server then

server.on("commandMessage", {
    arguments = {sf.string},
    handler = function(sender_uname, commandName, ...)
        --[[
            this is for when the player does any of the following:
            /commandName ...
            !commandName ...
            ;commandName ...
            ?commandName ...
            $commandName ...
        ]]
        local cmdHandler = commandToHandler[commandName]
        if not cmdHandler then
            chat.privateMessage(sender_uname, "unknown command: " .. commandName)
            return
        end

        local ok, err = cmdHandler.typechecker(...)
        if not ok then
            chat.privateMessage(sender_uname, "/" .. commandName .. ": " .. err)
            return
        end

        local adminLevel = chat.getAdminLevel(sender_uname)
        if cmdHandler.adminLevel > adminLevel then 
            chat.privateMessage(sender_uname, "/" .. commandName .. ": Admin level " .. tostring(handler.adminLevel) .. " required.")
            return
        end

        cmdHandler.handler(sender_uname, ...)
        server.broadcast("commandMessage", commandName, ...)
    end 
})

end




if client then

client.on("commandMessage", function(commandName, ...)
        local cmdHandler = commandToHandler[commandName]
        if cmdHandler then
            -- there may not be a handler for client.
            cmdHandler.handler(commandName, ...)
        end
    end 
)

end




function commands.getCommands()
    local buffer = objects.Array()
    for _, handler in pairs(commandToHandler) do
        buffer:add(handler) 
    end
    return buffer
end


return commands
