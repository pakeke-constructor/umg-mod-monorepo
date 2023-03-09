
local ClientContext = require("server.client_context")




umg.on("@playerJoin", function(username)
    -- Send etypes over so the client knows about them
    server.unicast(username, "worldeditorSetEntityTypes", server.entities)
end)



local editors = {--[[
    [username] --> ClientContext
]]}




server.on("worldeditorDefineTool", function(sender, tool, toolName)
    if not chat.isAdmin(sender) then
        return
    end

    editors[sender] = editors[sender] or ClientContext(sender)
    local cc = editors[sender]
    cc:defineTool(tool, toolName)
end)


server.on("worldeditorSetTool", function(sender, toolName)
    if not chat.isAdmin(sender) then
        return
    end

    editors[sender] = editors[sender] or ClientContext(sender)
    local cc = editors[sender]
    cc:setCurrentTool(toolName)
end)


server.on("worldeditorUseTool", function(sender, toolName, ...)
    if not chat.isAdmin(sender) then
        return
    end

    editors[sender] = editors[sender] or ClientContext(sender)
    local cc = editors[sender]
    local tool = cc:getCurrentTool(toolName)
    if tool then
        tool:apply(...)
    else
        chat.privateMessage(sender, "Couldn't find tool " .. toolName)
    end
end)



local BOOL_ALIASES = {
    on = true,
    off = false
}

local function handleAdminCommand(sender, a,b,c,d)
    if BOOL_ALIASES[a] then
        a = BOOL_ALIASES[a]
    end
    if a == true or a == false then
        server.unicast(sender, "worldeditorSetMode", a)
    end
    -- TODO:
    -- Can do other stuff here.
    -- perhaps fudge with settings and whatnot?
    -- eg    /worldeditor settings.xyz foo
end



chat.handleAdminCommand("worldeditor", handleAdminCommand)
chat.handleAdminCommand("worldedit", handleAdminCommand)

