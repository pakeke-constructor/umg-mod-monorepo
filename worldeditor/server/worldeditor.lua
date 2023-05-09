
local ClientContext = require("server.client_context")




umg.on("@playerJoin", function(username)
    -- Send etypes over so the client knows about them
    server.unicast(username, "worldeditorSetEntityTypes", server.entities)
end)



local editors = {--[[
    [username] --> ClientContext
]]}


local sf = sync.filters

local REQUIRED_ADMIN_LEVEL = 100

local function isAdmin(sender)
    return chat.getAdminLevel(sender) > REQUIRED_ADMIN_LEVEL
end

local function isValidTool(tool)
    if sf.table(tool) then
        -- todo: Do better checks here!
        return true
    end
    return false
end


server.on("worldeditorDefineTool", {
    arguments = {isValidTool, sf.string},
    handler = function(sender, tool, toolName)
        if not isAdmin(sender) then
            return
        end

        editors[sender] = editors[sender] or ClientContext(sender)
        local cc = editors[sender]
        cc:defineTool(tool, toolName)
    end
})


server.on("worldeditorSetTool", {
    arguments = {sf.string},
    handler = function(sender, toolName)
        if not isAdmin(sender) then
            return
        end

        editors[sender] = editors[sender] or ClientContext(sender)
        local cc = editors[sender]
        cc:setCurrentTool(toolName)
    end
})


server.on("worldeditorUseTool", {
    arguments = {sf.string},
    handler = function(sender, toolName, ...)
        if not isAdmin(sender) then
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
    end
})




local commandHandler = {
    adminLevel = 100,
    arguments = {{type = "boolean", name = "mode"}},

    handler = function(sender, bool)
        server.unicast(sender, "worldeditorSetMode", bool)
        -- TODO:
        -- Can do other stuff here.
        -- perhaps fudge with settings and whatnot?
        -- eg    /worldeditor settings.xyz foo
    end
}

chat.handleCommand("worldeditor", commandHandler)
chat.handleCommand("worldedit", commandHandler)


